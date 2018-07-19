-- 
--[[
---> 业务API路由
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local ipairs = ipairs
local pairs = pairs
local type = type
local require = require
local xpcall = xpcall
local pcall = pcall

local s_format = string.format
local s_lower = string.lower
local n_log = ngx.log
local n_err = ngx.ERR
local n_info = ngx.INFO
local s_lower = string.lower
-----------------------------------------------------------------------------------------------------------------

---> 加载插件式API
local base_router = require("app.routes.base_router")

-----------------------------------------------------------------------------------------------------------------

return function(conf, store)
    -- local stat_api = require("app.plugins.stat.api")
    local _router = base_router(conf, store, "api_router")
    return _router:load_router(function ( router )
        --- 插件信息
        -- 当前加载的插件，开启与关闭情况, 每个插件的规则条数等
        router:get("/plugins", function(req, res, next)
            local plugins = _router:load_plugins()

            res:json({
                success = true,
                data = {
                    plugins = plugins
                }
            })
        end)
    end)
end

