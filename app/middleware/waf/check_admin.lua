-- 
--[[
---> 500错误插件
--]]
--
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local n_log = ngx.log
local n_err = ngx.ERR

local s_find = string.find
local s_match = string.match

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 工具引用
local u_object = require("app.utils.object")

-----------------------------------------------------------------------------------------------------------------

return function()
	return function(req, res, next)
		local match, err = s_match(req.path, "^/admin/")

		if match then
			local user = req and req.session and req.session.get("user")
			local is_admin = user and u_object.check(user.is_admin)

		    if is_admin then
		    	next()
		    else
		    	if s_find(req.headers["Accept"], "application/json") then
	        		return res:json({
	        			success = false,
	        			msg = "该操作需要管理员权限."
	        		})
	        	else
	            	return res:render("error",{
	            		errMsg = "该操作需要管理员权限."
	            	})
	            end
		    end
		end

		next()
	end
end