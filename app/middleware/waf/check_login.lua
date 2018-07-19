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
local u_each = require("app.utils.each")

-----------------------------------------------------------------------------------------------------------------

local function get_login(req)
    local user = req.session and req.session.get("user")

    if user and user.username and user.userid then  
        return true, user
    end
    
    return false, nil
end

return function(white_list)
	return function(req, res, next)
	    local in_white_list = false
        
        u_each.array_action(white_list, function (_, v)
	    	local match, err = s_match(req.path, v)
	        if match then
                in_white_list = true
                return false
            end
        end)

		local is_login, user = get_login(req)

	    if in_white_list then
        	res.locals.login = is_login
        	res.locals.username = user and user.username
        	res.locals.is_admin = user and user.is_admin
        	res.locals.userid = user and user.userid
        	res.locals.create_time = user and user.create_time
            next()
	    else
	        if is_login then
	        	res.locals.login = true
	        	res.locals.username = user.username
	        	res.locals.is_admin = user.is_admin
				res.locals.userid = user.userid
				res.locals.create_time = user.create_time
	            next()
	        else
	        	if s_find(req.headers["Accept"], "application/json") then
	        		res:json({
	        			success = false,
	        			msg = "该操作需要先登录."
	        		})
	        	else
	            	res:redirect("/auth/login")
	            end
	        end
	    end

	end
end