-- 
--[[
---> 用于落地操作来自于（）的数据
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
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
local o_repo = require("app.store.orm.base_repo")

-----> 工具引用
--local u_object = require("app.utils.object")
--local u_each = require("app.utils.each")
--local u_db = require("app.utils.db")

-----> 外部引用
--local c_json = require("cjson.safe")
--------------------------------------------------------------------------


--[[
---> 当前对象
--]]
local model = o_repo:extend()

-----------------------------------------------------------------------------------------------------------------

--[[
---> 实例构造器
------> 子类构造器中，必须实现 model.super.new(self, store, self._name)
--]]
function model:new(config, store)
	-- 指定名称
	self._source = "[sys_logs]"
	self._store_node = store.db["default"] or store.db[""]

	-- 传导至父类填充基类操作对象
    model.super.new(self, self._source, self._store_node)
end

-----------------------------------------------------------------------------------------------------------------

--[[
---> 特殊自定义需求ok，records
--]]
-- function model:find_(attr)
-- 	local cond, params = self:resolve_attr(attr)
-- 	return self.adapter.current_model.find_all(cond, table.unpack(params))
-- end

-----------------------------------------------------------------------------------------------------------------

return model