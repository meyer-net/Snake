--
--[[
---> 用于操作来自于网关Orange中的数据
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local require = require

local s_format = string.format
local s_sub = string.sub
local s_gsub = string.gsub
local s_match = string.match

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
-----> 基础库引用
local l_object = require("app.lib.classic")

-----> 工具引用
local u_object = require("app.utils.object")
local u_table = require("app.utils.table")
local u_each = require("app.utils.each")
local u_string = require("app.utils.string")
local u_locker = require("app.utils.locker")

-----> 外部引用
local c_json = require("cjson.safe")

-----> 必须引用
local lor = require("lor.index")
--------------------------------------------------------------------------

return function ( config, store )
	local router = lor:Router() -- 生成一个router对象
	local s_log = require("app.model.service.sys.log_svr")
	local tmp_svr = s_log(config, store)

	-- http://192.168.1.176/log/save
	router:get("/save", function(req, res, next)
		local ok, id = tmp_svr:write_log(n_debug, "test write log at '%s'", ngx.localtime())

        res:json({
            success = ok,
            data = {
            	id = id
        	}
        })
	end)

	-- http://192.168.1.176/log/remove/3
	router:get("/remove/:id", function(req, res, next)
		local ok, effects = tmp_svr:remove_log({
				id = req.params.id
        	})

        res:json({
            success = ok,
            data = effects
        })
	end)

	-- http://192.168.1.176/log/refresh/2
	router:get("/refresh/:id", function(req, res, next)
        local id = req.params.id
        local content = s_format("| test refresh log at '%s'", ngx.localtime())

		local ok, effects = tmp_svr:refresh_log(id, content)

        res:json({
            success = ok,
            data = effects
        })
	end)

	-- http://192.168.1.176/log/get/2
	router:get("/get/:id", function(req, res, next)
		local data = tmp_svr:get_log(req.params.id)

        res:json({
            success = u_object.check(data),
            data = data
        })
	end)

	-- http://192.168.1.176/log/query
	router:get("/query", function(req, res, next)
		local data = tmp_svr:query_logs(req.params)

        res:json({
            success = u_object.check(data),
            data = data
        })
	end)

	return router
end