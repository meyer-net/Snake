-- 
--[[
---> 用于落地存储来自于客户端传递的流量数据
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
--------------------------------------------------------------------------
---> Examples：
-----> local r_flow_log = require("app.model.repository.flow_log")
-----> local tbl_flow_log = r_flow_log(store)

-----> local success = tbl_flow_log:append({
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
    self._name = (name or "flow_log") .. "-repository-model"
    
    -- 用于操作缓存与DB的对象
    self.store = store
end

-----------------------------------------------------------------------------------------------------------------

--[[
---> 追加一条记录
--]]
function _obj:append(params)
	local command_text = "INSERT INTO `flow_log` (`gid`, `shunt`, `source`, `medium`, `data`, `buffer_time`, `client_host`, `create_date`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
	local command_params = { params.gid, params.shunt, params.source, params.medium, params.data, params.buffer_time, params.client_host, params.create_date }

	return self.store.db:insert({
                sql = command_text,
                params = command_params
            })
end

-----------------------------------------------------------------------------------------------------------------

return _obj