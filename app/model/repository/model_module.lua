-- 
--[[
---> 用于落地存储来自于（）的数据
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
--------------------------------------------------------------------------
---> Examples：
-----> local r_model_module = require("app.model.repository.model_module")
-----> local tbl_model_module = r_model_module(store)

-----> local success = tbl_model_module:append({
-----> 		shunt = "b.test-x => utmcmd.test", 
-----> 		source = "b.test-x", 
-----> 		medium = "utmcmd.test", 
-----> 		data = "{ }"
-----> 	})
--]]
--
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local require = require
local s_format = string.format
--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 基础库引用
local object = require("app.lib.classic")

-----> 工具引用
--local u_object = require("app.utils.object")
--local u_each = require("app.utils.each")

-----> 外部引用
--local c_json = require("cjson.safe")

-----------------------------------------------------------------------------------------------------------------

--[[
---> 当前对象
--]]
local _obj = object:extend()

--[[
---> 实例构造器
------> 子类构造器中，必须实现 _obj.super.new(self, store, self._name)
--]]
function _obj:new(config, store, name)
	-- 指定名称
    self._name = (name or "model_module") .. "-repository-model"
    
    -- 用于操作缓存与DB的对象
    self.store = store
end

-----------------------------------------------------------------------------------------------------------------

--[[
---> 追加一条记录
--]]
-- function _obj:append(params)
-- 	local command_text = "INSERT INTO `model_module` (`gid`, `create_date`) VALUES (?, ?)"
-- 	local command_params = { params.gid }

-- 	return self.store.db:insert({
--                 sql = command_text,
--                 params = command_params
--             })
-- end

-----------------------------------------------------------------------------------------------------------------

return _obj