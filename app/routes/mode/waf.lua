-- 
--[[
---> 业务路由
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
--------------------------------------------------------------------------
local require = require

--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 工具引用
local u_string = require("app.utils.string")
local u_object = require("app.utils.object")

---> 业务路由管理
local router_simple_user = require("app.routes.waf.simple_user")
local router_auth = require("app.routes.waf.auth")
local router_user = require("app.routes.waf.user")

-----> 插件库引用
local middleware_session = require("lor.lib.middleware.session")
local middleware_er4xx = require("app.middleware.Er4xx")
local middleware_waf_check_login = require("app.middleware.waf.check_login")
local middleware_waf_check_admin = require("app.middleware.waf.check_admin")

---> 加载插件式API
local base_router = require("app.routes.base_router")

-----------------------------------------------------------------------------------------------------------------

return function(app, conf, store)
    ---> 管理员用户操作
    -- app:use("/user", router_simple_user(conf, store))

    if conf.waf and u_object.check(conf.waf.auth) then
        -- session support
        app:use(middleware_session({
            secret = conf.waf.session_secret or "12345678", -- lua-resty-string: salt must be 8 characters or nil
            timeout = conf.waf.session_timeout or 3600 -- default session timeout is 3600 seconds
        }))

        -- intercepter: login or not
        app:use(middleware_waf_check_login(conf.waf.white_list))

        -- auth router
        app:use("auth", router_auth(conf, store)())

        -- check if the current user is admin
        app:use(middleware_waf_check_admin())

        -- admin router
        app:use("admin", router_user(conf, store)())
    end

    local _router = base_router(conf, store, "waf_router")
    return _router:load_router(function (router)
        -- 没有特殊的数据渲染，则按请求路径展示HTML
        app:erroruse(middleware_er4xx(function (req, res, next)
            local uri = u_string.ltrim(ngx.var.uri, "/")
            res:render(uri)
        end))

        router:get("/", function(req, res, next)
            res:render("index",  {
                plugins = conf.plugins,
                plugin_configs = _router:load_plugins()
            })
        end)

        router:get("/monitor/rule/statistic", function(req, res, next)
            local rule_id = req.query.rule_id;
            local rule_name = req.query.rule_name or "";
            res:render("monitor-rule-stat", {
                rule_id = rule_id,
                rule_name = rule_name
            })
        end)
        
        router:get("/basic_auth", function(req, res, next)
            res:render("basic_auth/basic_auth")
        end)

        router:get("/signature_auth", function(req, res, next)
            res:render("signature_auth/signature_auth")
        end)

        router:get("/key_auth", function(req, res, next)
            res:render("key_auth/key_auth")
        end)
    end)
end