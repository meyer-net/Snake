local base_api = require("app.plugins.base_api")

local api = base_api:new("logic-buffer-api")
api:merge_apis({
		["/test"] = {
		    POST = function(config, store)
			    return function(req, res, next)

			    	local lock = require "resty.lock"
                	local locker = lock:new("sys_buffer_locker")
	
                	local elapsed, err = locker:lock("my_key")
    				if not elapsed then
    				    ngx.log(ngx.ERR, "Failed to acquire the lock: ", err)
    				    return
    				end

    				for i=1,1000 do
    					ngx.say(i)
    				end
	
                	local ok, err = locker:unlock()
                	if not ok then
                	    ngx.say("failed to unlock: ", err)
                	end
                	ngx.say("unlock: ", ok)

				    local result = {
				        success = success,
				        data = data
				    }
		
				    res:json(result)
				end
			end
		}
	})

return api