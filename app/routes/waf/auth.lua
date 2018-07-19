--
--[[
---> 用于操作来自于网关Orange中的数据
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local require = require

local s_format = string.format
local s_sub = string.sub
local s_gsub = string.gsub
local s_match = string.match

local n_today = ngx.today

local n_log = ngx.log
local n_err = ngx.ERR
local n_info = ngx.INFO
local n_debug = ngx.DEBUG
--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 基础库引用
local l_object = require("app.lib.classic")

-----> 工具引用
local u_object = require("app.utils.object")
local u_table = require("app.utils.table")
local u_each = require("app.utils.each")
local u_string = require("app.utils.string")

-----> 外部引用
local c_json = require("cjson.safe")

-----> 必须引用
local lor = require("lor.index")

-----> 业务引用
local s_user = require("app.model.service.sys.user_svr")

--------------------------------------------------------------------------

return function ( config, store )
	local router = lor:Router() -- 生成一个router对象
	local tmp_svr = s_user(config, store)

    router:get("/login", function(req, res, next)
        res:render("login")
    end)

    router:post("/login", function(req, res, next)
        local username = req.body.username
        local password = req.body.password

        if not u_object.check(username) or not u_object.check(password) then
            return res:json({
                success = false,
                msg = "用户名和密码不得为空."
            })
        end

        local is_exist = false
        local userid = 0

        local user = tmp_svr:check_user(username, password)
        local is_exist = u_object.check(user)

        if is_exist then
            userid = user.id
        else
            is_exist = false
        end

        if is_exist then
            local is_admin = u_object.check(user.is_admin)
            local username = user.username

            if is_admin then
                n_log(n_info, "管理员[", username, "]登录")
            else
                n_log(n_info, "普通用户[", username, "]登录")
            end

            req.session.set("user", {
                username = username,
                is_admin = is_admin,
                userid = userid,
                create_time = user.create_time or ""
            })
            return res:json({
                success = true,
                msg = "登录成功."
            })
        else
            return res:json({
                success = false,
                msg = "用户名或密码错误，请检查!"
            })
        end
    end)

    router:get("/logout", function(req, res, next)
        res.locals.login = false
        res.locals.is_admin = false
        res.locals.username = ""
        res.locals.userid = 0
        res.locals.create_time = ""
        req.session.destroy()
        res:redirect("/auth/login")
    end)

	return router
end