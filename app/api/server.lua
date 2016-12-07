-- 
--[[
---> 主服务文件
--]]
--
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local type = type
local ipairs = ipairs

local encode_base64 = ngx.encode_base64
local string_lower = string.lower
local string_format = string.format
local string_gsub = string.gsub

local n_log = ngx.log
local n_err = ngx.ERR
local n_info = ngx.INFO
local n_debug = ngx.DEBUG

--[[
---> 统一引用导入APP-LIBS
--]]
-----> 基础库引用
local lor = require("lor.index")

-----> 插件库引用
local middleware_er4xx = require("app.middleware.Er4xx")
local middleware_er5xx = require("app.middleware.Er5xx")

-----------------------------------------------------------------------------------------------------------------

--[[
---> 内部私有函数
--]]
--------------------------------------------------------------------------
-----> 验证失败时
local function auth_failed(res)
    res:status(401):json({
        success = false,
        msg = "Not Authorized."
    })
end

-----> 获取编码值
local function get_encoded_credential(origin)
    local result = string_gsub(origin, "^ *[B|b]asic *", "")
    result = string_gsub(result, "( *)$", "")

    return result
end

-----------------------------------------------------------------------------------------------------------------

--[[
---> 当前对象
--]]
local _M = {}

--[[
---> 实例构造器
--]]
function _M:new(config, store)
    local instance = {}
    instance.config = config
    instance.store = store
    instance.app = lor()

    setmetatable(instance, { __index = self })
    instance:build_app()
    return instance
end

--[[
---> 生产APP
--]]
function _M:build_app()
    local config = self.config
    local store = self.store
    local app = self.app

    local router = require("api.router")
    
    -------------------------------------------------------------------------------------------------------------

    local auth_enable = config and config.api and config.api.auth_enable
    local credentials = config and config.api and config.api.credentials
    local illegal_credentials = (not credentials or type(credentials) ~= "table" or #credentials < 1)

    -- basic-auth middleware
    app:use(function(req, res, next)
        if not auth_enable then return next() end
        if illegal_credentials  then return auth_failed(res) end

        local authorization = req.headers["Authorization"]
        if type(authorization) == "string" and authorization ~= "" then
            local encoded_credential = get_encoded_credential(authorization)

            for i, v in ipairs(credentials) do
                local allowd = encode_base64(string_format("%s:%s", v.username, v.password))
                if allowd == encoded_credential then
                    next()
                    return
                end
            end
        end
            
        auth_failed(res)
    end)

    ---> 业务路由处理：
    app:use(router(config, store)())
    
    --[[
    ---> 公共部分的插件引用
    --]]
    ---> 404 error
    app:use(middleware_er4xx())
    
    ---> 错误处理插件，可根据需要定义多个
    app:erroruse(middleware_er5xx())
end

--[[
---> 获取APP
--]]
function _M:get_app()
    return self.app
end

-----------------------------------------------------------------------------------------------------------------

return _M
