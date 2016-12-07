local lor = require("lor.index")

return function ( config, store )
	local router = lor:Router() -- 生成一个router对象

	router:get("/", function (req, res, next)
		local lib = require("resty.http")
		
		local res_c,err_c = ngx.location.capture('/buffer_notify', { 
				method = ngx.HTTP_GET, 
				body = 'hello, world' 
			})

		if res_c.status == ngx.HTTP_OK then
			res:send("OK")
 		end

		res:send(res_c.status)
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
	router:get("/db", function(req, res, next)
		local r_flow_log = require("app.model.repository.flow_log")
		local tbl_flow_log = r_flow_log(config, store)
	
		local success = tbl_flow_log:append({
				shunt = "b.test-x => utmcmd.test", 
				source = "b.test-x", 
				medium = "utmcmd.test", 
				data = "{ }"
			})

        res:json({
            success = success,
            data = {
                key = key
            }
        })
	end)

	-- CACHE测试 http://192.168.1.205/test/cc/rds
	router:get("/cc/rds", function(req, res, next)
		local ok, err = store.cache.redis["default"]:lpush("test.cc.rds", "rds test")

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

	-- CACHE测试 http://192.168.1.205/test/buffer?utmcsr=bt.x&utmcmd=sem&a=1&b=2&c=3
	router:get("/buffer", function(req, res, next)
	end)

	return router
end
