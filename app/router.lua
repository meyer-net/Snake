---> 函数指针
local type = type
local pairs = pairs
local pcall = pcall

local s_format = string.format
local s_lower = string.lower
local n_log = ngx.log
local n_err = ngx.ERR
local n_info = ngx.INFO

---> 包导入
local lor = require("lor.index")

---> 业务路由管理
local router_test = require("app.routes.test")
local router_gateway = require("app.routes.gateway")
local router_buffer = require("app.routes.buffer")
local router_log = require("app.routes.log")

-----> 插件库引用
local middleware_er4xx = require("app.middleware.Er4xx")

---> 加载插件式API
local function load_plugin_api(plugin, router, store)
    local plugin_api_path = s_format("app.plugins.%s.api", plugin)
    local ok, plugin_api = pcall(require, plugin_api_path)

    if not ok or not plugin_api or type(plugin_api) ~= "table" then
        print("[app.router => plugin's api load error], plugin_api_path:", plugin_api_path)
        return
    end

    for uri, api_methods in pairs(plugin_api) do
        n_log(n_info, "load route, uri:", uri)
        if type(api_methods) == "table" then
            for method, func in pairs(api_methods) do
                local m = s_lower(method)
                if m == "get" or m == "post" or m == "put" or m == "delete" then
                    router[m](router, uri, func(store))
                end
            end
        end
    end
end

return function(app, config, store)

    ---> 控制路由是否采用严格模式匹配，即是否严格区分’/test’和’/test/‘
    ---> 相关参考：http://lor.sumory.com/guide/strict_route.html
    app:conf("strict_route", false)

    ---> group router, 对以`/test`开始的请求做过滤处理
    app:use("/test", router_test(config, store))

    ---> 网关操作
    app:use("/gateway", router_gateway(config, store))

    ---> 请求缓冲
    local ins_router_buffer, buffer_all_request = router_buffer(config, store)
    app:use("/buffer", ins_router_buffer)

    ---> 数字操作
    app:use("/log", router_log(config, store))

    ---> 除使用group router外，也可单独进行路由处理，支持get/post/put/delete...

    ---> render html, visit "/view" or "/view?name=foo&desc=bar
    app:get("/", function(req, res, next)
        local data = {
            name = req.query.name or config.sys.name,
            desc = req.query.desc or config.sys.desc,
            author = req.query.author or config.sys.author
        }
        
        res:render("index", data)
    end)

    ---> help for sys!
    app:get("/help", function(req, res, next)
        res:send("hi! welcome to use help.")
    end)
    
    ---> all req route to buffer node
    ---> 特殊情况，将404引入至此，所有404均视为buffer
    app:erroruse(middleware_er4xx(buffer_all_request))

    ---> 加载其他"可用"插件API
    local router = lor:Router()
    local available_plugins = config.plugins
    if not available_plugins or type(available_plugins) ~= "table" or #available_plugins<1 then
        n_log(n_err, "no available plugins, maybe you should check `sys.conf`.")
    else
        for _, plugin in ipairs(available_plugins) do
            load_plugin_api(plugin, router, store)
        end
    end

    return router
end