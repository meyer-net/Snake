local _M = {}

-- buffer 与 trigger 的区别在于，buffer由客户端推动，trigger由后台推动
function _M.buffer(config, store)
    local args = ngx.req.get_post_args()
    if not args then
        return false, {
            message = "data exception"
        }
    end

    local flow_shunt = require("app.model.service.flow_shunt")(config, store)
    local len, err, success = flow_shunt:buffer(require("cjson.safe").decode(args.data))

    return success, {
            length = len,
            message = err
        }
end

-- 用作没有推广信息过来时，触发式完成接下来队列中任务
function _M.trigger(config, store)
    local flow_shunt = require("app.model.service.flow_shunt")(config, store)
    
    local list = flow_shunt:push_redundant_data()
    return success, {
            list = list
        }
end

return _M
