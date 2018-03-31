-- 
--[[
---> 404错误插件
--]]
--
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local n_log = ngx.log
local n_err = ngx.ERR

local s_find = string.find
local s_format = string.format

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 工具引用
local u_object = require("app.utils.object")

-----------------------------------------------------------------------------------------------------------------
return function(action404)
	return function(err, req, res, next)
		if not req:is_found() then
			if not action404 then
				local _not_found_text = "404！Sorry，Action not found。"
				local _str_headers = req.headers["Accept"]
				if u_object.check(_str_headers) and s_find(_str_headers, "application/json") then
					res:status(404):json({
						success = false,
						msg = _not_found_text
					})
				else
					res:status(404):send(_not_found_text)
				end
	
				n_log(n_err, s_format("error(%s) ===> %s", req.path, _not_found_text))
			else
				action404(req, res, next)
			end
		else
			next()
		end
	end
end