-- 
--[[
---> 
--------------------------------------------------------------------------
---> 参考文献如下
-----> 
--------------------------------------------------------------------------
---> Examples：
-----> 
--]]
--
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local require = require

local n_log = ngx.log
local n_err = ngx.ERR
local n_info = ngx.INFO
local n_debug = ngx.DEBUG

local n_today = ngx.today

local s_format = string.format
local s_sub = string.sub
local s_gsub = string.gsub
local t_insert = table.insert
--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 基础库引用
local r_http = require("resty.http")
local l_object = require("app.lib.classic")

-----> 工具引用
local u_object = require("app.utils.object")
local u_each = require("app.utils.each")
local u_locker = require("app.utils.locker")

-----> 外部引用
local c_json = require("cjson.safe")

-----> 数据资源引用
local r_flow_log = require("app.model.repository.flow_log")

-----------------------------------------------------------------------------------------------------------------

--[[
---> 当前对象
--]]
local _obj = l_object:extend()

--[[
---> 实例构造器
------> 子类构造器中，必须实现 _obj.super.new(self, store, self._name)
--]]
function _obj:new(config, store, name)
	-- 指定名称
    self._name = (name or "flow_shunt") .. " service model"
    
    -- 用于操作缓存与DB的对象
    self.store = store
    self.store.cache.native_nginx = store.cache.nginx["sys_plugin_buffer"]
    self.store.cache.native_redis = store.cache.redis["default"]
    self.store.cache.intranet_redis = store.cache.redis["intranet"]

    -- 配置文件
    self.config = config

    -- 锁对象
    self.locker = u_locker(self.store.cache.nginx["sys_locker"], "buffer-timer")

	-- 位于在缓存中维护的KEY值
    self.cache_prefix = s_format("%s.app.(%s)_", config.app_name, self._name)
end

-----------------------------------------------------------------------------------------------------------------

--[[
---> 此处针对冗余段的数据PUSH操作
--]]
function _obj:push_redundant_data()
	local push_set = {}
    local last_locker_release_time = self.locker:get_action_release_time("sys_buffer_locker")
    -- 最后执行超过轮询秒数2倍后，会被强制执行此段
    local this_time = ngx.now()
    local interval_time = this_time - (last_locker_release_time or this_time)

    if interval_time > self.config.sys.buffer.interval_seconds * 3 then
        -- 轮询所有 KEYS
        local key_prefix = s_format("%s%s^*", self.cache_prefix, "buffer")
        local keys = self.store.cache.native_redis:keys(key_prefix)
        if keys then
        	u_each.array_action(keys, function ( _, cache_key )
        		local len, l_err
        	    local ok, f_err = pcall(function()
	                    len, l_err = self:push(cache_key, self)
	                end)

				t_insert(push_set, {
					key = cache_key,
					res = ok,
					len = len,
					err = l_err or f_err
					})
        	end)
        end
    end

    return push_set
end

--[[
---> 此处进行数据分流，缓冲操作
--]]
function _obj:buffer(args)
	-- 用作分流的依据
	local shunt = s_format("[%s/%s]", args.utmcsr, args.utmcmd)
	-- 查询缓存或数据库中是否包含指定信息
	local cache_key = s_format("%s%s^%s", self.cache_prefix, "buffer", shunt)

	-- 1：预先堆叠到本地 redis-queue 中，由到达一定量后再进行内网同步，以减少内网通信交互操作
	local buffer_json = c_json.encode({
			params = args,
			atts = {
				create_time = ngx.time(),
				client_host = ngx.var.remote_addr
			}
		})
	local res, err = self.store.cache.native_redis:lpush(cache_key, buffer_json)
    local success = not err

    if success then
        -- 日志阶段产生时间，避免响应被阻塞
        ngx.ctx.after_log = function ()
			-- 延后X秒，执行PUSH命令(启用延迟Y秒执行（依据缓存，来控制PUSH时间间隔，避免同一时刻产生多次PUSH叠加）)
		    local ok, err = ngx.timer.at(0, function(premature)
		            local ok, err = self.locker:action("sys_buffer_locker", function ()
		                    return pcall(function()
		                        self:push(cache_key, self)
		                    end)
		                end, self.config.sys.buffer.interval_seconds)

		            if not ok or err then
						n_log(n_err, s_format("METHOD:[service.%s.buffer] QUEUE:[%s] lock action failure! error: %s", self._name, queue_name, err))
		            end
		        end)

		    if not ok then
				n_log(n_err, s_format("METHOD:[service.%s.buffer] QUEUE:[%s] create the timer failure! error: %s", self._name, queue_name, err))
		    end
        end
    else
		n_log(n_err, s_format("METHOD:[service.%s.buffer] QUEUE:[%s] lpush failure! error: %s", self._name, cache_key, err))
    end

	return res, err, success
end

--[[
---> 此处进行汇总推送
--]]
function _obj:push(queue_name, this)
	this = this or self
	----：获取当前队列长度
	local len, err = this.store.cache.native_redis:llen(queue_name)
	if len and not err then
		local push_set = {}
		local start_id = 1
		local res, err

    	local fmt_today = s_gsub(n_today(), "-", "")
    	local fmt_day = s_sub(fmt_today, 7, 8)

		-- 1：批量落库缓冲数据，只操作当期长度数据
		for i = 1,len,1 do 
			-- 读取队列数据
			res, err = this.store.cache.native_redis:rpop(queue_name)

			if res then
				local data = c_json.decode(res)
				local tbl_flow_log = r_flow_log(this.config, this.store)
				local res_db, err = tbl_flow_log:append({
					gid = tonumber(fmt_day),
					shunt = s_format("%s[%s]", data.params.utmcsr, data.params.utmcmd), 
					source = data.params.utmcsr, 
					medium = data.params.utmcmd, 
					data = c_json.encode(data.params),
					buffer_time = data.atts.create_time,
					client_host = data.atts.client_host,
					create_date = fmt_today
				})

				if i == 1 then
					start_id = res_db.insert_id
				end

				t_insert(push_set, res_db.insert_id)
				t_insert(push_set, res)
			else
				n_log(n_err, s_format("METHOD:[service.%s.push_rpop] QUEUE:[%s] failure! error: %s", this._name, queue_name, err))
			end
		end

		-- 2：完成对缓冲后落库数据的迁移
		local cache_key = s_format("%s.%s>%s", queue_name, start_id, start_id + len)
		local ok, err = this.store.cache.intranet_redis:hmset(cache_key, push_set)
		if err then
			n_log(n_err, s_format("METHOD:[service.%s.push_dest] QUEUE:[%s] failure! error: %s res: %s", this._name, queue_name, err, res))
		end

		-- 3：通知统计方，执行后续任务
		--local res_c,err_c = ngx.location.capture('/buffer_notify', { 
		--		method = ngx.HTTP_POST, 
		--		body = 'hello, world' 
		--	})
		local http = r_http:new()
		local res_c, err_c = http:request_uri(this.config.sys.buffer.notify_url, {
    	    method = "POST",
    	    headers = {
    	    	["key"] = cache_key
    		}
    	})
	
		-- X：异步回调后，更新落库缓存，数据操作状态
		if res_c then
			n_log(n_info, s_format("METHOD:[service.%s.push.http] key:[%s] success! status: %s, error: %s", this._name, queue_name, res_c.status, err_c))
		else
			n_log(n_err, s_format("METHOD:[service.%s.push.http] key:[%s] failure! status: %s, error: %s", this._name, queue_name, res_c.status, res_c:read_body()))
 		end
	else
		n_log(n_err, s_format("METHOD:[service.%s.push_getlen] QUEUE:[%s] failure! error: %s", this._name, queue_name, err))
	end

	return len, err
end

-----------------------------------------------------------------------------------------------------------------

return _obj