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

return function ( conf, store )
	local router = lor:Router() -- 生成一个router对象
	local s_user = require("app.model.service.user_svr")
	local tmp_svr = s_user(conf, store)

	-- http://192.168.1.176/user
	router:post("", function(req, res, next)
		local ok, id = tmp_svr:regist_user({
        	    username = "newer_"..require("app.utils.math").random(),
        	    password = require("app.lib.uuid")(),
        	    is_admin = 0,
        	    enable = 1
        	})

        res:json({
            success = ok,
            data = {
            	id = id
        	}
        })
	end)

	-- http://192.168.1.176/user/3
	router:delete("/:id", function(req, res, next)
		local ok, effects = tmp_svr:remove_user({
				id = req.params.id
        	})

        res:json({
            success = ok,
            data = effects
        })
	end)

	-- http://192.168.1.176/user/5
	router:put("/:id", function(req, res, next)
		local ok, effects = tmp_svr:refresh_user({
				id = req.params.id,
        	    username = "updated_"..require("app.utils.math").random(),
        	    password = require("app.lib.uuid")()
        	})

        res:json({
            success = ok,
            data = effects
        })
	end)

	-- http://192.168.1.176/user/2
	router:get("/:id", function(req, res, next)
		local data = tmp_svr:get_user(req.params.id)

        res:json({
            success = u_object.check(data),
            data = data
        })
	end)

	-- http://192.168.1.176/user/list
	router:get("/list", function(req, res, next)
		local data = tmp_svr:query_users(req.params)

        res:json({
            success = u_object.check(data),
            data = data
        })
	end)

	return router
end