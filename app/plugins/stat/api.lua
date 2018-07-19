-- 
--[[
---> {壳子类}用于将当前插件提供为对外API
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
--------------------------------------------------------------------------
local require = require
local s_format = string.format
--------------------------------------------------------------------------

--[[
---> 统一引用导入APP-LIBS
--]]
--------------------------------------------------------------------------
-----> 基础库引用
local base_api = require("app.plugins.base_api")

-----> 逻辑引用
local p_stat = require("app.plugins.stat.stat")

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
local api = base_api:extend()

-----------------------------------------------------------------------------------------------------------------

--[[
---> 实例构造器
------> 子类构造器中，必须实现 api.super.new(self, name)
--]]
function api:new(name)
	-- 传导至父类填充基类操作对象
	api.super.new(self, name)
	
	-- 合并现有逻辑
	self:merge_apis({
		["/stat/status"] = {
			GET = function(store)
				return function(req, res, next)
					local stat_result = p_stat.stat()

					local result = {
						success = true,
						data = stat_result
					}

					res:json(result)
				end
			end
		}
	})
end

-----------------------------------------------------------------------------------------------------------------

return api