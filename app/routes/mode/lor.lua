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
---> 业务路由管理
local router_test = require("app.routes.test")
local router_buffer = require("app.routes.buffer")
-- local router_log = require("app.routes.log")

-----> 插件库引用
local middleware_er4xx = require("app.middleware.Er4xx")

---> 加载插件式API
local base_router = require("app.routes.base_router")

-----------------------------------------------------------------------------------------------------------------

return function(app, conf, store)
    ---> group router, 对以`/test`开始的请求做过滤处理
    app:use("/test", router_test(conf, store))

    ---> 数字操作
    -- app:use("/log", router_log(conf, store))
    
    ---> 除使用group router外，也可单独进行路由处理，支持get/post/put/delete...

    ---> render html, visit "/view" or "/view?name=foo&desc=bar
    app:get("/", function(req, res, next)
        local data = {
            name = req.query.name or conf.sys.name,
            desc = req.query.desc or conf.sys.desc,
            author = req.query.author or conf.sys.author
        }
        
        res:render("index", data)
    end)

    ---> help for sys!
    app:get("/help", function(req, res, next)
        res:send("hi! welcome to use help.")
    end)
    
    ---> all req route to buffer node
    ---> 请求缓冲，特殊情况，将404引入至此，所有404均视为buffer
    local ins_router_buffer, buffer_all_request = router_buffer(conf, store)
    app:use("/buffer", ins_router_buffer)
    app:erroruse(middleware_er4xx(buffer_all_request))
    
    return base_router(conf, store, "lor_router"):load_router()
end