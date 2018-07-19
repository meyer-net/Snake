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

local n_var = ngx.var
local n_req = ngx.req
local n_err = ngx.ERR
local n_info = ngx.INFO
local n_debug = ngx.DEBUG
--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 基础库引用
local m_base = require("app.model.base_model")
local l_uuid = require("app.lib.uuid")

-----> 工具引用
--

-----> 外部引用
--

-----> 数据仓储引用（???buffer配合更多的是hdfs写入，DB无法承载如此级别的持久化操作，此处由于hdfs未实现，暂时禁用）
-----> repository的base_repo将修正问base_db_repo，同时扩展base_hdfs_repo。
-- local r_buffer = require("app.model.repository.sys.buffer_repo")
local s_log = require("app.model.service.sys.log_svr")

-----------------------------------------------------------------------------------------------------------------

--[[
---> 当前对象
--]]
local model = m_base:extend()

--[[
---> 实例构造器
------> 子类构造器中，必须实现 model.super.new(self, store, self._name)
--]]
function model:new(conf, store, name)
	-- 指定名称
    self._source = "svr.sys.buffer"

    -- 传导值进入父类
    model.super.new(self, conf, store, "svr.sys.buffer")

	-- 位于在缓存中维护的KEY值
    self._cache_prefix = self.format("%s.app<%s> => ", conf.project_name, self._name)

    -- 当前临时操作数据的仓储
    self._model.log = s_log(conf, store, self._name)
end

-----------------------------------------------------------------------------------------------------------------

--[[
---> 缓冲请求信息
--]]
function model:write_request(key)
    local headers = n_req.get_headers()
    headers["host"] = headers["x-real-ip"]

    -- 移出不要的头部信息
    self.utils.table.clean_fields(headers, {
        "accept",
        "x-forwarded-scheme", 
        "x-forwarded-for", 
        "x-real-ip", 
        "connection", 
        "accept-encoding", 
        "upgrade-insecure-requests", 
        "cache-control"
    })
    
    local args = self.utils.json.decode(n_var.args) or n_var.args    
    if not self.utils.object.check(args) then
        return false, "no args checked", 0
    end

    local data_packet = {
        Uri = n_var.uri,
        Args = args,
        Method = n_req.get_method(),
        ReceiveTime = ngx.now(),
        Headers = headers
    }
    -- ngx.log(n_err, self.utils.json.encode(data_packet))
    -- 交给异步子线程跑（ngx.timer.at 貌似有次数限制，有待确认）
    -- local ok, err = ngx.timer.at(0, function()
    -- end)
    return self:write(key or n_var.uri, data_packet, true)
end

--[[
---> 缓冲一条信息
--]]
function model:write(key, value, partition)
    -- 转换json为字符串
    if type(value) ~= "string" then
        value = self.utils.json.encode(value)
    end
    
    -- 查看长度，redis: lrange "buffer->topic{test}all_" 0 -1
    local ok, err, offset = self._store.buffer.using:lpush(key, value, partition)
    self._model.log:write_log(n_info, value)
    if not ok then
        self._model.log:write_log(n_err, err)
    end
    
    return ok, err, offset
end

-----------------------------------------------------------------------------------------------------------------

return model