local base_api = require("app.plugins.base_api")
local buffer = require("app.plugins.logic.buffer")

local api = base_api:new("logic-buffer-api")
api:merge_apis({
		["/buffer"] = {
		    POST = function(config, store)
			    return function(req, res, next)
				    local success,data = buffer.buffer(config, store)
		
				    local result = {
				        success = success,
				        data = data
				    }
		
				    res:json(result)
				end
			end
		},
		["/trigger"] = {
		    GET = function(config, store)
			    return function(req, res, next)
				    local success,data = buffer.trigger(config, store)
		
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