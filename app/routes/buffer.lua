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

-----> 业务引用
local s_buffer = require("app.model.service.sys.buffer_svr")
--------------------------------------------------------------------------

return function ( config, store )
	local router = lor:Router() -- 生成一个router对象

	local done_all_request = function(req, res, next)
		ngx.var.args = u_object.set_if_empty(ngx.var.args, function()
			return c_json.encode(req.body)
		end)
		
		local tmp_svr = s_buffer(config, store)
		local ok, err, offset = tmp_svr:write_request("test")

		res:status(202):json({
			success = ok,
			data = {
				offset = offset
			},
			message = err
		})
	end

	router:all("", done_all_request)

	return router, done_all_request
end