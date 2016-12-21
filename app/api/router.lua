---> 函数指针
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

---> 包导入
local lor = require("lor.index")

---> 加载插件式API
local function load_plugin_api(plugin, api_router, config, store)
    local plugin_api_path = "app.plugins." .. plugin .. ".api"
    print("[app.api.router => plugin's api load], plugin_api_path:", plugin_api_path)

    local ok, plugin_api, e
    ok = xpcall(function() 
        plugin_api = require(plugin_api_path)
    end, function()
        e = debug.traceback()
    end)

    if not ok or not plugin_api or type(plugin_api) ~= "table" then
        n_log(n_err, "[app.api.router => plugin's api load error], plugin_api_path:", plugin_api_path, " error:", e)
        return
    end

    local plugin_apis = plugin_api:get_apis()
    for uri, api_methods in pairs(plugin_apis) do
        n_log(n_info, "load route, uri:", uri)
        if type(api_methods) == "table" then
            for method, func in pairs(api_methods) do
                local m = s_lower(method)
                if m == "get" or m == "post" or m == "put" or m == "delete" then
                    api_router[m](api_router, uri, func(config, store))
                end
            end
        end
    end
end

return function(config, store)
    local api_router = lor:Router()

    --- 插件信息
    -- 当前加载的插件，开启与关闭情况, 每个插件的规则条数等
    api_router:get("/plugins", function(req, res, next)
        local available_plugins = config.plugins

        local plugins = {}
        for i, v in ipairs(available_plugins) do
            local tmp = {
                enable = true,  -- 默认全部启用
                name = v,
                active_rule_count = 0,
                inactive_rule_count = 0
            }

            plugins[v] = tmp
        end

        res:json({
            success = true,
            data = {
                plugins = plugins
            }
        })
    end)

    --- 加载其他"可用"插件API
    local available_plugins = config.plugins
    if not available_plugins or type(available_plugins) ~= "table" or #available_plugins<1 then
        return api_router
    end

    for i, p in ipairs(available_plugins) do
        load_plugin_api(p, api_router, config, store)
    end

    return api_router
end

