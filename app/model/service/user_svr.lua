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

--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 基础库引用
local m_base = require("app.model.base_model")

-----> 工具引用
--

-----> 外部引用
--

-----> 数据仓储引用
local r_user = require("app.model.repository.user_repo")
local s_log = require("app.model.service.sys.log_svr")

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
            password = params.password,
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
    local mdl = {
            username = params.username,
            password = params.password,
            is_admin = params.is_admin,
            enable = params.enable
        }

    local attr = {
            id = params.id
        }

    return self._model.current_repo:update(mdl, attr)
end

--[[
---> 查询单个用户
--]]
function model:get_user(id)
    -- 查询缓存或数据库中是否包含指定信息
    local cache_key = self.format("%s%s -> %s", self.cache_prefix, self._source, id)
    local timeout = 0
    
    return self._store.cache.using:get_or_load(cache_key, function() 
        return self._model.current_repo:find_one({
                id = id
            })
    end, timeout)
end

--[[
---> 查询所有的用户
--]]
function model:query_users()
	-- 查询缓存或数据库中是否包含指定信息
    local cache_key = self.format("%s%s -> %s", self.cache_prefix, self._source, "*")
  	local timeout = 0
	
  	return self._store.cache.using:get_or_load(cache_key, function() 
        return self._model.current_repo:find_all({

            })
  	end, timeout)
end

-----------------------------------------------------------------------------------------------------------------

return model