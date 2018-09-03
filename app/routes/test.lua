--[[
---> 统一函数指针
--]]
local require = require

local s_format = string.format
local s_sub = string.sub
local s_gsub = string.gsub
local s_match = string.match
local s_lower = string.lower

local t_insert = table.insert

local n_today = ngx.today

local n_log = ngx.log
local n_err = ngx.ERR
local n_info = ngx.INFO
local n_debug = ngx.DEBUG
--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 工具引用
local u_object = require("app.utils.object")
local u_table = require("app.utils.table")
local u_each = require("app.utils.each")
local u_string = require("app.utils.string")
local u_locker = require("app.utils.locker")
local u_math = require("app.utils.math")

-----> 外部引用
local c_json = require("cjson.safe")

-----> 必须引用
local lor = require("lor.index")

return function ( config, store )
	local router = lor:Router() -- 生成一个router对象

	router:get("/error", function (req, res, next)
		local log_level = {
			error = ngx.ERR,
			debug = ngx.DEBUG,
			info = ngx.INFO,
			notice = ngx.NOTICE,
			warn = ngx.WARN,
			crit = ngx.CRIT,
			alert = ngx.ALERT,
			emerg = ngx.EMERG
		}

		res:json(log_level)
	end)

	router:get("/time", function(req, res, next)
		local time_array = {
            today = ngx.today(),
            time = ngx.time(),
            now = ngx.now(),
            update_time = ngx.update_time(),
            localtime = ngx.localtime(),
            utctime = ngx.utctime()
		}

		local l_date = require("app.lib.date")()
		local u_time = require("app.utils.time")

		local current_minute = u_time.current_minute()
		local current_minute_int = u_string.to_time(current_minute)

        res:json({
        	date = string.sub(time_array.utctime, 1, 10),
        	date_day = string.sub(time_array.utctime, 9, 10),
        	date_until_minute = string.sub(time_array.utctime, 1, 16),
            weekday = os.date("%w", os.time()),
            ngx = {
            	time_array = time_array
        	},
        	date_lib = {
        		time_array = {
        			date = l_date:getdate(),
        			time = l_date:gettime()
        		}
        	},
        	time_lib = {
        		time_array = {
        			now = u_time.now(),
        			current_timetable = u_time.current_timetable(),
        			current_day = u_time.current_day(),
        			current_hour = u_time.current_hour(),
        			current_minute = current_minute,
        			current_second = u_time.current_second(),
        			minute_to_time = current_minute_int,
        			minute_from_time = u_time.to_string(current_minute_int)
        		}
        	}
        })
	end)

	router:get("/locker", function(req, res, next)
		local time = nil
		local ok, err = u_locker(store.cache.nginx["sys_locker"], "test_locker"):action("sys_landing_locker", function ()
            return pcall(function()
            	time = ngx.now()
            	print("t ---> 1111111111")
            	n_log(n_err, "t ---> 2222222222")
            	return
            end)
        end)

		res:json({
			ok = ok, 
			err = err,
			data = {
				time = time
			}
        })
	end)

	router:get("/", function (req, res, next)		
		local res_c,err_c = ngx.location.capture('/robots.txt', { 
				method = ngx.HTTP_GET, 
				body = 'hello, world' 
			})

		if res_c.status == ngx.HTTP_OK then
			res:send("OK")
 		end
	end)

	-- AES 加密测试
	router:get("/aes/:data", function(req, res, next)
		local s_aes = require("app.security.aes")
		local n_aes = s_aes()
		local key = "12345678901234561234567890123456"
	
		local encrypted_base64 = n_aes:encrypt_tob64(key, req.params.data)
	    local decrypted_text = n_aes:decrypt_fromb64(key, encrypted_base64)

        res:json({
            success = true,
            data = {
                key = key,
                encrypted_base64 = encrypted_base64,
                decrypted_text = decrypted_text
            }
        })
	end)

	-- DB测试
	router:get("/orm", function(req, res, next)
		local orm = store.db["default"] or store.db[""]
		-- local orm = require('app.store.orm.adapter')({
		--   	driver = 'mysql', -- or 'postgresql'
		--   	port = 8066,
		--   	host = '127.0.0.1',
		--   	user = 'root',
		--   	password = '123456',
		--   	database = 'user',
		--   	charset = 'utf8mb4',
		--   	expires = 100,  -- cache expires time
		--   	debug = true -- log sql with ngx.log 
		-- }):open()

		--local sql = orm.create_query():from('[sys_users]'):where('[id] = ?d', 1):one()
		-- NOTICE: 
		--		the table must have an auto increment column as its primary key
		-- 		define_model accept table name as paramater and cache table fields in lrucache.
		-- expr(expression, ...)
		-- 		?t table {1,2,'a'} => 1,2,'a'
		-- 		?b bool(0, 1), only false or nil will be converted to 0 for mysql, TRUE | FALSE in postgresql
		-- 		?e expression: MAX(id) | MIN(id) ...
		-- 		?d digit number, convert by tonumber
		-- 		?n NULL, false and nil wil be converted to 'NULL', orther 'NOT NULL'
		-- 		?s string, escaped by ngx.quote_sql_str
		-- 		? any, convert by guessing the value type
		-- METHODS:
		-- 		Model.new([attributes]) create new instance
		-- 		Model.query() same as orm.create_query():from(Model.table_name())
		-- 		Model.find() same as query(), but return Model instance
		-- 		Model.find_one(cond, ...) find one record by condition
		-- 		Model.find_all(cond, ...) find all records by condition
		-- 		Model.update_where(attributes, cond, ...) update records filter by condition
		-- 		Model.delete_where(cond, ...) delete records filter by condition
		-- 		
		-- 		model:save() save the record, if pk is not nil then update() will be called, otherwise insert() will be called
		-- 		
		-- 		model:load(attributes) load attributes to instance
		-- 		model:set_dirty(attribute) make attribute dirty ( will be updated to database )
		-- 		model:is_new() return if this instance is new or load from database

		local m_usr = orm.define_model('[sys_users]')

		-- create new 
		local attrs = { 
			username = 'new user',
			password = require("app.lib.uuid")(),
			is_admin = 0,
			enable = 1
		}

		local i_usr = m_usr.new(attrs)

		-- 可能引发重复值冲突错误：Bad result: Duplicate entry 'new user' for key 'unique_username', 1062, 23000
		local ok, id = i_usr:save()

		local model_find_one_success, model_find_one = m_usr.find_one('id = ?d', id)

		-- UPDATE tbl_user SET name='name updated' WHERE id > 10
		local attrs = { username = 'name updated' }
		m_usr.update_where(attrs, 'id = ?d', id)

		local model_find_success, model_find = m_usr.find():where('id = ?d', id):limit(1)()

		-- DELETE FROM tbl_user WHERE id = 10
		m_usr.delete_where('id = ?d', id) --delete all by condition
		i_usr:delete()  -- delete user instance

		local model_find_all_success, model_find_all = m_usr.find_all('id > ?d', 0)

		-- orm.transaction(function(conn)
		--     m_usr.new{ username = 'mow' }:save()
		--     -- conn:commit()
		--     conn:rollback()
		-- end)

        res:json({
            success = model_find_one_success and model_find_success and model_find_all_success,
            data = {
            	model_find_one = model_find_one,
            	model_find = model_find,
            	model_find_all = model_find_all,
            	--model_query = m_usr:query()
        	}
        })
	end)

	-- CACHE测试 http://192.168.1.205/test/cc/rds
	router:get("/cc/rds", function(req, res, next)
		local s_cache = require("app.store.cache.base_cache")
		local t_cache = store.cache.redis["default"]

		local ok, err = t_cache:append("test.cc.rds", "rds test "..ngx.now(), 5)

        res:json({
            success = not err,
            data = {
                length = ok,
                message = err
            }
        })
	end)

	-- CACHE测试 http://192.168.1.205/test/cc/ngx
	router:get("/cc/ngx", function(req, res, next)
		local ok, err = store.cache.nginx["sys_plugin_buffer"]:set("test.cc.rds", "ngx test")

        res:json({
            success = ok,
            data = {
                message = err
            }
        })
	end)

	-- CACHE测试 http://192.168.1.176/test/stock/000001
	router:get("/stock/import/:code", function(req, res, next)
		local code = s_lower(req.params.code)
		local line_index = 0
		local message = ""
		local url = s_format("http://table.finance.yahoo.com/table.csv?s=%s&c=2012", code)

  		--local io = require("io")
      	local handle = io.popen("curl -L "..url)
      	local stock_text = handle:read("*a")
      	local lines = handle:lines()

		local orm = store.db["default"] or store.db[""]
  		--local io = require("io")
		for line in lines do
  			local array = u_string.split(line, ",")
  			local date = array[1]
  			
  			if s_lower(date) ~= "date" then
  				local open = tonumber(array[2])
  				local high = tonumber(array[3])
  				local low = tonumber(array[4])
  				local close = tonumber(array[5])
  				--local volume = array[6]
  				--local adj = array[7]
  				local stock_data = {
  					code = code,
  					date = date,
					open = open,
					high = high,
					low = low,
					close = close
  				}
	
				local m_data = orm.define_model('[stock_data]')
				local i_data = m_data.new(stock_data)
	
				local ok, id = i_data:save()
				if not ok then
					message = s_format("%s %s", message, ok)
				end

  				line_index = line_index + 1
  			end
		end

      	handle:close()

		local m_result = orm.define_model('[stock_result]')
		local i_result = m_result.new({
				code = code,
				count = line_index,
				success = line_index > 0,
				message = message
			})
		i_result:save()

    	res:json({
    		code = code,
    		success = line_index > 0,
    	    count = line_index,
    	    message = message,
    	    time = ngx.utctime()
    	})
	end)

	-- CACHE测试 http://192.168.1.176/test/stock/000001
	router:get("/stock/:code", function(req, res, next)
		local http = require("resty.http").new()
		http:set_timeout(5000)
		local u_string = require("app.utils.string")
		local u_each = require("app.utils.each")
		local u_table = require("app.utils.table")
-- 
		local url = s_format("http://table.finance.yahoo.com/table.csv?s=%s.sz", req.params.code)
		local callback, err = http:request_uri(url, {
      	  	method = "POST",
      	  	body = "",
      	  	headers = {
      	  	  ["Content-Type"] = "application/x-www-form-urlencoded",
      	  	}
      	})
-- 
		if callback then
      		local stock_text = callback.body
      		local stock_table = u_table.reverse(u_string.split(stock_text, "\n"))
      		local stock = {}
      		local current = 1
	
      		local min001 = 0
      		local min002 = 0
-- 
      		local min001open_close_index = 1
      		local min001open_close = { }
-- 
      		local min002open_close_index = 1
      		local min002open_close = { }
-- 
      		local yes_close = 0
      		u_each.array_action(stock_table, function ( idx, line )
      			local array = u_string.split(line, ",")
      			local date = array[1]
      			local open = tonumber(array[2])
      			local high = tonumber(array[3])
      			local low = tonumber(array[4])
      			local close = tonumber(array[5])
      			--local volume = array[6]
      			--local adj = array[7]
-- 
      			if open then
					local u_time = require("app.utils.time")
					local today = u_string.to_time(u_time.current_day())
					local date_day = u_string.to_time(date)
-- 
					if (today - date_day) <= 31536000 then			
      					if yes_close == 0 then
      						stock[current] = 0
      					else
      						local value = tonumber(s_format("%.2f", (open - yes_close) / yes_close))
-- 
      						if value <= -0.02 then
      							min002open_close[min002open_close_index] = {
      								date = date,
      								open = open,
      								close = close,
      								yes_close = yes_close
      							}
-- 
      							min002open_close_index = min002open_close_index + 1
      							min002 = min002 + 1
      						end
      						
      						if value <= -0.01 then
      							min001open_close[min001open_close_index] = {
      								date = date,
      								open = open,
      								close = close,
      								yes_close = yes_close
      							}
-- 
      							min001open_close_index = min001open_close_index + 1
      							min001 = min001 + 1
      						end
-- 
      						stock[current] = value
-- 
      						current = current + 1
      					end
-- 
      					yes_close = close
					end
      			end
      		end)
	
        	res:json({
        	    success = ok,
        	    data = {
        	    	url = url,
        	    	lines = #stock,
        	    	min001 = min001,
        	    	min001open_close = min001open_close,
        	    	min002 = min002,
        	    	min002open_close = min002open_close,
        	        message = stock
        	    }
        	})
        else
        	res:json({
        	    success = false,
        	    data = {
        	        message = "timeout"
        	    }
        	})
        end
	end)

  -- 在当前莱昂币的基础上，生成日K数据
  router:post("/weight_rand", function(req, res, next)

    local weight_conf = {
        {
            rdm_begin = 0.50,
            rdm_end = 1.20,
            weight = '0.1%'
        },
        {
            rdm_begin = 0.30,
            rdm_end = 1.00,
            weight = '0.3%'
        },
        {
            rdm_begin = 0.30,
            rdm_end = 0.88,
            weight = '0.6%'
        },
        {
            rdm_begin = 0.30,
            rdm_end = 0.66,
            weight = '1%'
        },
        {
            rdm_begin = 0.20,
            rdm_end = 0.55,
            weight = '2%'
        },
        {
            rdm_begin = 0.10,
            rdm_end = 0.33,
            weight = '7%'
        },
        {
            rdm_begin = 0.01,
            rdm_end = 0.10,
            weight = '15%'
        },
        {
            rdm_begin = -0.10,
            rdm_end = 0.10,
            weight = '75%'
        }
    }

    local confs = {}
    for i=1,5 do
        local conf_node = u_math.weight_rand(weight_conf)
        local value = u_math.random_range(conf_node.rdm_begin, conf_node.rdm_end)
        confs[i] = value --u_math.weight_rand(weight_conf)
    end

    res:json(confs)
  end)

  router:get("/rpc_leaf", function(req, res, next)
	
	local server_address = "172.30.10.115"
	local server_port = 2182

		local rpc = require "resty.skynet_rpc"
            local r= rpc.new()	
						r:set_timeout(1000)
						r:connect(server_address, server_port)
						local v = r:call("getID","GET","a")
            ngx.log(ngx.ERR, v)
						r:set_keepalive(5000)

	-- local proxy = luarpc.createProxy(server_address, server_port, interface_file)

	-- local t = proxy.getID()
	
    res:json({r=v})
  end)

	return router
end