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
    return base_router(conf, store, "api_router"):load_router(function ( router, conf, store, cache )
        --- 插件信息
        -- 当前加载的插件，开启与关闭情况, 每个插件的规则条数等
        router:get("/plugins", function(req, res, next)
            local available_plugins = conf.plugins

            local plugins = {}
            for i, v in ipairs(available_plugins) do
                local tmp
                if v ~= "kvstore" then
                    tmp = {
                        enable =  cache:get(v .. ".enable"),
                        name = v,
                        active_selector_count = 0,
                        inactive_selector_count = 0,
                        active_rule_count = 0,
                        inactive_rule_count = 0
                    }
                    
                    local plugin_selectors = cache:get_json(v .. ".selectors")
                    if plugin_selectors then
                        for sid, s in pairs(plugin_selectors) do
                            if s.enable == true then
                                tmp.active_selector_count = tmp.active_selector_count + 1
                                local selector_rules = cache:get_json(v .. ".selector." .. sid .. ".rules")
                                for _, r in ipairs(selector_rules) do
                                    if r.enable == true then
                                        tmp.active_rule_count = tmp.active_rule_count + 1
                                    else
                                        tmp.inactive_rule_count = tmp.inactive_rule_count + 1
                                    end
                                end
                            else
                                tmp.inactive_selector_count = tmp.inactive_selector_count + 1
                            end
                        end
                    end
                else
                    tmp = {
                        enable =  (v=="stat") and true or (cache:get(v .. ".enable") or false),
                        name = v
                    }
                end
                
                plugins[v] = tmp
            end

            res:json({
                success = true,
                data = {
                    plugins = plugins
                }
            })
        end)
    end)
end

