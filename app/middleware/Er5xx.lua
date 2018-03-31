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

-----------------------------------------------------------------------------------------------------------------

return function()
	return function(err, req, res, next)
			n_log(n_err, err)
			local _error_text = "Unknow error 500，Server is busying！"
			if s_find(req.headers["Accept"] or "", "application/json") then
				res:status(500):json({
					success = false,
					msg = _error_text
				})
			else
		    	res:status(500):send(_error_text)
		    end
		end
	end