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

-----------------------------------------------------------------------------------------------------------------
return function()
	return function(req, res, next)
		    if req:is_found() ~= true then
		    	local _not_found_text = "404！Sorry，Action not found。"
		    	if s_find(req.headers["Accept"], "application/json") then
		    		res:status(404):json({
		    			success = false,
		    			msg = _not_found_text
		    		})
		    	else
		        	res:status(404):send(_not_found_text)
		        end
		
				n_log(n_err, s_format("error(%s) ===> %s", req.path, _not_found_text))
		    end
		end
	end