local base_handler = require("app.plugins.base_handler")
local stat = require("app.plugins.stat.stat")

local handler = base_handler:extend()

handler.PRIORITY = 2000

function handler:new()
    handler.super.new(self, "stat-plugin")
end

function handler:init_worker(conf)
    stat.init()
end

function handler:log(conf)
    stat.log()
end

return handler
