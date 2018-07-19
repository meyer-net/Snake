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
local s_format = string.format

--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
---> 业务路由管理
local router_test = require("app.routes.test")
local router_user = require("app.routes.user")
local router_buffer = require("app.routes.buffer")
local router_log = require("app.routes.log")

-----> 插件库引用
local middleware_er4xx = require("app.middleware.Er4xx")

---> 加载插件式API
local base_router = require("app.routes.base_router")
local mode_router_lor = require("app.routes.mode.lor")
local mode_router_waf = require("app.routes.mode.waf")

-----------------------------------------------------------------------------------------------------------------

return function(app, conf, store)

    ---> 控制路由是否采用严格模式匹配，即是否严格区分’/test’和’/test/‘
    ---> 相关参考：http://lor.sumory.com/guide/strict_route.html
    app:conf("strict_route", false)
    
    return require(s_format("app.routes.mode.%s", conf.view_config.mode))(app, conf, store)
end