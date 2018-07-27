-- 
--[[
---> 
--------------------------------------------------------------------------
---> 参考文献如下
-----> 
--------------------------------------------------------------------------
---> Examples：
-----> 
--]]
--
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local require = require

local s_lower = string.lower

--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 基础库引用
local m_base = require("app.model.base_model")

-----> 工具引用
local u_each = require("app.utils.each")
local s_sha256 = require("app.security.sha256")

-----> 外部引用
--

-----> 数据仓储引用
local r_user = require("app.model.repository.sys.user_repo")
local s_log = require("app.model.service.sys.log_svr")
local var_secret = "ae005ceb7e9a217cced2f8aa354187c7"

-----------------------------------------------------------------------------------------------------------------

--[[
---> 当前对象
--]]
local model = m_base:extend()

--[[
---> 实例构造器
------> 子类构造器中，必须实现 model.super.new(self, conf, store, name)
--]]
function model:new(conf, store, name)
	-- 指定名称
    self._source = "svr.user"

    -- 传导值进入父类
    model.super.new(self, conf, store, name)

	-- 位于在缓存中维护的KEY值
    self.cache_prefix = self.format("%s.app<%s> => ", conf.project_name, self._name)

    -- 当前临时操作数据的仓储
    self._model.log = s_log(conf, store)
    self._model.current_repo = r_user(conf, store)
end

-----------------------------------------------------------------------------------------------------------------

--[[
---> 注册一个用户
--]]
function model:regist_user(params)
    local mdl = {
            username = params.username,
            password = s_sha256:encode(params.password .. "#" .. var_secret),
            is_admin = params.is_admin,
            enable = params.enable
        }

    return self._model.current_repo:save(mdl, false)
end

--[[
---> 删除一个用户
--]]
function model:remove_user(params)
    local attr = {
            id = params.id
        }

    return self._model.current_repo:delete(attr)
end

--[[
---> 刷新一个用户信息
--]]
function model:refresh_user(params)
    local mdl = {}
    u_each.json_action(params, function(k, v)
        if s_lower(k) == "password" then
            mdl[k] = s_sha256:encode(v .. "#" .. var_secret)
        else
            mdl[k] = v
        end
    end)

    local attr = {
            id = params.id
        }

    return self._model.current_repo:update(mdl, attr)
end

--[[
---> 查询单个用户
--]]
function model:get_user(id)
    return self:get_user_by({
        id = id
    })
end

--[[
---> 查询单个用户
--]]
function model:get_user_by(mdl)
    -- 查询缓存或数据库中是否包含指定信息
    local cache_key = self.format("%s%s -> %s", self.cache_prefix, self._source, id)
    local timeout = 1
    
    return self._store.cache.using:get_or_load(cache_key, function() 
        return self._model.current_repo:find_one(mdl)
    end, timeout)
end

--[[
---> 查询所有的用户
--]]
function model:query_users()
	-- 查询缓存或数据库中是否包含指定信息
    local cache_key = self.format("%s%s -> %s", self.cache_prefix, self._source, "*")
    local timeout = 1
    
  	return self._store.cache.using:get_or_load(cache_key, function() 
        return self._model.current_repo:find_all({

            })
  	end, timeout)
end

--[[
---> 验证用户
--]]
function model:check_user(username, password)
	-- 查询缓存或数据库中是否包含指定信息
    local cache_key = self.format("%s%s -> %s", self.cache_prefix, self._source, username)
  	local timeout = 0
	
    password = s_sha256:encode(password .. "#" .. var_secret)
  	return self._store.cache.using:get_or_load(cache_key, function() 
        return self._model.current_repo:find_one({
                username = username,
                password = password
            })
  	end, timeout)
end

-----------------------------------------------------------------------------------------------------------------

return model