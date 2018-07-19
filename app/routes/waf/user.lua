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

local s_len = string.len
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
local u_locker = require("app.utils.locker")

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

    router:get("/user/manage", function(req, res, next)
        res:render("user_manage")
    end)

	router:get("/users", function(req, res, next)
		local users = tmp_svr:query_users()
		
        return res:json({
            success = true,
            data = {
                users = users
            }
        })
    end)

    router:post("/user/new", function(req, res, next)
		local user = (req.session and req.session.get("user")) or {}
        if not user.is_admin then
            return res:json({
                success = false,
                msg = "您的身份不是管理员，不允许创建用户."
            })
        end

        local username = req.body.username 
        local password = req.body.password
        local enable = req.body.enable

        local pattern = "^[a-zA-Z][0-9a-zA-Z_]+$"
        local match, err = s_match(username, pattern)

        if not username or not password or username == "" or password == "" then
            return res:json({
                success = false,
                msg = "用户名和密码不得为空."
            })
        end

        local username_len = s_len(username)
        local password_len = s_len(password)

        if username_len<4 or username_len>50 then
            return res:json({
                success = false,
                msg = "用户名长度应为4~50位."
            })
        end
        if password_len<6 or password_len>50 then
            return res:json({
                success = false,
                msg = "密码长度应为6~50位."
            })
        end

        if not match then
           return res:json({
                success = false,
                msg = "用户名只能输入字母、下划线、数字，必须以字母开头."
            })
        end

        local result, err = tmp_svr:get_user_by({
			username = username
		})
        local isExist = false
        if result and not err then
            isExist = true
        end

        if isExist == true then
            return res:json({
                success = false,
                msg = "用户名已被占用，请修改."
            })
        else
            local ok, id = tmp_svr:regist_user({
				username = username, 
				password = password, 
				enable = enable
			})

            if ok then
                return res:json({
                    success = true,
                    msg = "新建用户成功.",
                    data = {
                        users = tmp_svr:query_users()
                    }
                })  
            else
                return res:json({
                    success = false,
                    msg = "新建用户失败."
                }) 
            end
        end
    end)

    router:post("/user/modify", function(req, res, next)
		local user = (req.session and req.session.get("user")) or {}
        if not user.is_admin then
            return res:json({
                success = false,
                msg = "您的身份不是管理员，不允许修改用户."
            })
        end

        local password = req.body.new_pwd
        

        local user_id = req.body.user_id
        if not user_id then
            return res:json({
                success = false,
                msg = "用户id不能为空"
            })
        end

        local enable = req.body.enable
        if not u_object.check(password) then -- 无需更改密码
            local ok, effects = tmp_svr:refresh_user({
				enable = enable,
				id = user_id
			})
            if ok then
                return res:json({
                    success = true,
                    msg = "修改用户成功.",
                    data = {
                        users = tmp_svr:query_users()
                    }
                })  
            else
                return res:json({
                    success = false,
                    msg = "修改用户失败."
                }) 
            end
        else
        	local password_len = s_len(password)
            if password_len<6 or password_len>50 then
                return res:json({
                    success = false,
                    msg = "密码长度应为6~50位."
                })
            end

            local result = tmp_svr:refresh_user({
				password = password, 
				enable = enable,
				id = user_id
			})
            if result then
                return res:json({
                    success = true,
                    msg = "修改用户成功.",
                    data = {
                        users = tmp_svr:query_users()
                    }
                })  
            else
                return res:json({
                    success = false,
                    msg = "修改用户失败."
                }) 
            end
        end
    end)

    router:post("/user/delete", function(req, res, next)
		local user = (req.session and req.session.get("user")) or {}
        if not user.is_admin then
            return res:json({
                success = false,
                msg = "您的身份不是管理员，不允许删除用户."
            })
        end

        local user_id = req.body.user_id
        if not user_id then
            return res:json({
                success = false,
                msg = "用户id不能为空"
            })
        end

        local ok, effects = tmp_svr:remove_user({
			id = user_id
		})
        if ok then
            return res:json({
                success = true,
                msg = "删除用户成功.",
                data = {
                    users = tmp_svr:query_users()
                }
            })  
        else
            return res:json({
                success = false,
                msg = "删除用户失败."
            }) 
        end
        
    end)

	return router
end