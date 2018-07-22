--
--[[
---> 用于操作来自于鉴权的系列流程，并将请求下发至下游系统。
--------------------------------------------------------------------------
---> 参考文献如下
-----> /
-- 数据库配置数据
-- 特别注释
-- match_uri = "^/api"                                    -- 外层实则为匹配至选择器根路径
-- default_host = "127.0.0.1"                             -- 默认反向代理根路径
-- default_server = "http://127.0.0.1:5555"               -- 默认反向代理响应服务（一般为前端部署地址）
-- ident_field = "jwt"                                    -- 用于标识ident插件的描述字段，可自定义。但需与上下文匹配
-- ident_cookie = false                                   -- 用于指示ident标识信息是否由写入cookie完成
-- ident_from = "{user}/login",                           -- 依据该请求路径返回值判断是否产生新的JWT信息 { session_time, security_code, prev_security_code, uid }            
-- ident_destory = "{user}/logout",                       -- 依旧该请求路径销毁服务器所在JWT信息
-- ctrl_open = "{auth}/open",                             -- 验证是否为开放的控制器            
-- ctrl_pass = "{auth}/pass",                             -- 验证请求是否具备访问该URI的权限{"time":"2018-05-05 19:31:01","enable":true,"judge":{"conditions":[{"value":"^\/(.*)","operator":"match","type":"URI"}],"type":0},"id":"16a81a2e-bbd9-41a3-bd8f-5c8c4a487335","log":true,"name":"ALL","handle":{"log":true,"match_uri":"^\/api","ctrl_open":"{auth}\/api\/open","ctrl_pass":"{auth}\/api\/pass"},"default_host":"192.168.1.141","default_server":"http://192.168.1.141:9010", "ignore_static": true, "ident_field":"jwt", "ident_cookie": false,"ident_from":"{user}\/login","ident_destory":"{user}\/logout","server_nodes":{"user":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9002","match_uri":"\/user"},"www":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9005","match_uri":"\/www"},"ims":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9004","match_uri":"\/ims"},"order":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9001","match_uri":"\/order"},"wallet":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9003","match_uri":"\/wallet"},"auth":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9008","match_uri":"\/auth","is_open":false}},"extractor":{"extractions":[{"type":"URI","name":"uri"}],"type":1}}
-- 1 {"selectors":["32f54e1a-0b2e-4368-b773-7fe488df81d1"]} meta
-- 32f54e1a-0b2e-4368-b773-7fe488df81d1 {"time":"2018-05-05 14:37:02","enable":true,"rules":["16a81a2e-bbd9-41a3-bd8f-5c8c4a487335"],"id":"32f54e1a-0b2e-4368-b773-7fe488df81d1","judge":[],"name":"Monitor","handle":{"continue":true,"log":true},"type":0} selector

-- 前台分布式微服务
-- 16a81a2e-bbd9-41a3-bd8f-5c8c4a487335 {"time":"2018-05-05 19:31:01","enable":true,"judge":{"conditions":[{"value":"^\/(.*)","operator":"match","type":"URI"}],"type":0},"id":"16a81a2e-bbd9-41a3-bd8f-5c8c4a487335","log":true,"name":"ALL","handle":{"log":true,"match_uri":"^\/api","default_host":"192.168.1.141","default_server":"http://192.168.1.141:9010","ident_field":"jwt", "ident_cookie": false,"ident_from":"{user}\/login","ident_destory":"{user}\/logout","server_nodes":{"user":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9002","match_uri":"\/user"},"www":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9005","match_uri":"\/www"},"ims":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9004","match_uri":"\/ims"},"order":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9001","match_uri":"\/order"},"wallet":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9003","match_uri":"\/wallet"},"auth":{"server_host":"192.168.1.141","server_url":"http://192.168.1.141:9008","match_uri":"\/auth","is_open":false}},"ctrl_open":"{auth}\/api\/open","ctrl_pass":"{auth}\/api\/pass"},"extractor":{"extractions":[{"type":"URI","name":"uri"}],"type":1}}
                                        
-- 后台单节点
-- 16a81a2e-bbd9-41a3-bd8f-5c8c4a487335 {"time":"2018-05-05 19:31:01","enable":true,"judge":{"conditions":[{"value":"^\/(.*)","operator":"match","type":"URI"}],"type":0},"id":"16a81a2e-bbd9-41a3-bd8f-5c8c4a487335","log":true,"name":"ALL","handle":{"log":true,"match_uri":"","default_host":"127.0.0.1","default_server":"http://127.0.0.1:5555", "ignore_static": true, "ident_field":"jwt", "ident_cookie": false,"ident_from":"{api}\/manage\/users\/login","ident_destory":"{api}\/manage\/users\/logout","ctrl_open":"{api}\/auth\/open\/?format=json","ctrl_pass":"{api}\/auth\/pass\/?format=json","server_nodes":{"api":{"server_host":"192.168.1.148","server_url":"http://192.168.1.148:8765","match_uri":"^\/api"}}},"extractor":{"extractions":[{"type":"URI","name":"uri"}],"type":1}}
-----------------------------------------------------------------------------------------------------------------
--[[
---> 统一函数指针
--]]
local require = require

local s_format = string.format
local s_find = string.find
local s_sub = string.sub
local s_gsub = string.gsub

local n_var = ngx.var
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
local r_cookie = require("resty.cookie")
local base_handler = require("app.plugins.handler_adapter")

-----> 工具引用
local u_object = require("app.utils.object")
local u_table = require("app.utils.table")
local u_each = require("app.utils.each")
local u_args = require("app.utils.args")
local u_json = require("app.utils.json")
local u_string = require("app.utils.string")
local u_handle = require("app.utils.handle")
local u_request = require("app.utils.request")
local u_jwt = require("app.utils.jwt")
local u_judge = require("app.utils.judge")
local ue_error = require("app.utils.exception.error")

-----> 外部引用
local c_json = require("cjson.safe")

-----> 必须引用
--

-----> 业务引用
--

-----> 数据仓储引用
local s_log = require("app.model.service.sys.log_svr")

--------------------------------------------------------------------------

--[[
---> 实例信息及配置
--]]
local handler = base_handler:extend()

function handler:new(conf, store)
    self.PRIORITY = 9999

    -- 控件名称
    self._source = "ident_ctx"
    
	-- 传导至父类填充基类操作对象
    handler.super.new(self, conf, store)
    self._request = u_request(self._name)
    self._ident_cache = store.cache.using
    self._ident = u_jwt(self._name, self._ident_cache)  -- self._ident_cache

end

--------------------------------------------------------------------------

function handler:redirect()
    -- n_log(n_err, "load exec redirect")
end

-- ***??? 前置 http_referer 插件防止被钓鱼。
-- ***??? 前置 API调用级别优先 不然会与插件冲突。
function handler:rewrite()
    -- 基本信息获取
    local http_method = ngx.req.get_method():lower()

    local check_handle = function (rule)
        local rule_handle = rule.handle
        assert(rule_handle, s_format("[%s-rule-handle:load_handle_conf] %s -> can't load rule 'handle', maybe it's not exits", self._name, rule.name))

        return rule_handle
    end

    -- 检测函数是否合法并执行
    local check_func_exec = function(func, param)
        if func and type(func) == "function" then 
            return func(param)
        end

        return true, nil
    end

    -- 用于验证错误，并及时结束响应
    local case_error_exit = function (print_error)
        if print_error then
            ngx.print(c_json.encode(print_error))
            ngx.exit(ngx.HTTP_OK)
        end

        return true
    end

    -- 规则匹配后的具体逻辑
    local rule_pass_func = function (rule, variables, rule_matched)
        -- 加载远程鉴权信息，并执行上下文逻辑
        local load_api_exec = function (node, url, flow_args, payload, ok_exec, false_exec, ignore_event_code)
            -- 信息加载
            local args = u_table.merge(flow_args, u_args.get_from_ngx_req())
            local headers = u_table.merge({
                ["content-type"] = "application/json;charset=utf-8", --"application/json;charset=utf-8",
                ["payload"] = self.utils.json.encode(payload)
            }, ngx.req.get_headers())
            local api_print = self:_load_remote(node, "POST", headers, url, args)

            -- 特定的接口，不允许明文写入日志
            local log_args = c_json.encode(args)
            local log_args = (node == "ident_from" and "*deny display*") or log_args
            self:rule_log_debug(rule, s_format("[load-api-exec:%s:remote] url: %s, args: %s, resp: %s", node, url, log_args, c_json.encode(api_print)))

            local error_print = self:_get_print_from_ctrl(api_print, nil, ignore_event_code)
            if u_object.check(error_print) then
                self:rule_log_info(rule, s_format("[load-api-exec:%s:error] url: %s, args: %s, resp: %s", node, url, log_args, c_json.encode(error_print)))
            end
            
            -- 远程出错，信息流在此终止
            case_error_exit(error_print)

            -- 过滤BODY信息，对于存在错误的情况，直接返回输出
            error_print = nil
            local ok, err
            if u_object.check(api_print.res) then
                ok, err, error_print = check_func_exec(ok_exec, api_print)
            else
                ok, err, error_print = check_func_exec(false_exec, api_print)
            end
                
            -- 如果函数没有返回错误信息，且有返回执行结果，但结果却为false或出错的情况时中断
            if not error_print and ok ~= nil and (not ok or err) then
                error_print = ue_error.get_err(self.utils.ex.error.EVENT_CODE.program_err, err or "server is busying", api_print)
            end

            if error_print then
                case_error_exit(error_print)
            end
        end
        
        -- 流程1：加载配置文件
        local rule_handle = check_handle(rule)
    
        -- 流程2：匹配具体需请求的子系统
        local uri = n_var.uri
        local uri_args = n_var.query_string
        local micro_host = rule_handle.default_host
        local micro_url = rule_handle.default_server
        local ignore_static = rule_handle.ignore_static
        
        -- 启用静态了资源检测
        local is_needs_check = (ignore_static or ignore_static == nil) and not u_object.check(u_request:get_static_content_type())

        -------- 规则验证，匹配具体的upstream(host/url)
        local micro_uri = nil
        local server_name = n_var.server_name -- self._conf.project_name -- s_format("%s:%s", n_var.server_addr, n_var.server_port)
        if is_needs_check then
            ---- 展开JWT信息
            local ident_string = n_var["cookie_"..rule_handle.ident_field]
            local ident_csrf_token = n_var["cookie_"..rule_handle.ident_field.."_csrf_token"]
            local ident_is_ok, ident_event_code, ident_secret, ident_payload = self._ident:load(ident_string, ident_csrf_token or n_var.cookie_csrf_token)

            u_each.json_action(rule_handle.server_nodes, function ( micro_name, micro_conf )
                -- 检测节点是否对外开放
                if micro_conf.is_open ~= nil and not micro_conf.is_open then
                    return
                end

                local match_uri = micro_conf.match_uri
                local micro_pass, micro_match = u_judge.filter_and_conditions({{
                        value = match_uri,
                        operator = "match",
                        type = "URI"
                    }})
                
                if micro_pass then
                    micro_host = micro_conf.server_host
                    micro_url = micro_conf.server_url
                    micro_uri = s_gsub(uri, micro_match, "")
                    
                    local micro_first = s_sub(micro_uri, 1, 1)
                    if micro_first ~= "/" then
                        micro_uri = s_format("/%s", micro_uri)
                    end

                    -- 子系统的真实uri
                    local micro_uri_args = u_json.to_url_param(ngx.req.get_uri_args())
                    
                    -- 判断是否为JWT信息获取源接口
                    local micro_var = s_format("{%s}", micro_name)
                    
                    -- 路径匹配检测
                    local check_uri = function ( conf_uri )
                        local trim_conf_uri, _ = u_string.rtrim(u_string.trim_uri_args(conf_uri), "/")
                        local trim_micro_uri, _ = u_string.rtrim(micro_uri, "/")
                        local new_uri = s_gsub(trim_conf_uri, micro_var, "")
                        
                        if new_uri ~= trim_conf_uri then
                            local is_matched = new_uri == trim_micro_uri
                            self:rule_log_info(rule, s_format("[server-matched:{%s}] %s, conf_uri: %s, server_node: %s, server_uri: %s", match_uri, is_matched, conf_uri, micro_name, micro_uri))
                            return is_matched
                        end

                        return false
                    end

                    -- 路径检测 -> 是否为JWT获取源，JWT注销源
                    -- 此源头，直接取消反代，在本地进行命令输出
                    
                    local micro_req_url = s_format("%s%s%s", micro_url, micro_uri, (u_object.check(micro_uri_args) and s_format("?%s", micro_uri_args)) or "")
                    if check_uri(rule_handle.ident_from) then
                        -- 默认取客户端参数
                        load_api_exec("ident_from", micro_req_url, {
                            client_host = self._request.get_client_host(),
                            client_type = self._request.get_client_type(),
                            http_method = http_method,
                            server_name = server_name
                        }, nil, function(body)
                            local payload = body.dt
                            
                            local ok, err = self._ident:check(payload)
                            if not ok then
                                body.msg = err
                                return ok, err, body
                            end
                            
                            -- 删除过去存在的会话
                            self._ident_cache:del(ident_secret)
                            
                            local secret, ident_val = self._ident:generate(payload)
                            
                            local ok, err = self._ident_cache:set(secret, ident_val)

                            if ok and not err then
                                -- 写入COOKIE则不通过body响应
                                if u_object.check(rule_handle.ident_cookie) then
                                    -- ***??? 存在BUG，会重复写入客户端。(原因 httponly模式 会写入浏览器，而服务端会出现加载不到的情况)
                                    local cookie = r_cookie:new()
                                    local cookie_module = {
                                        domain = n_var.host,
                                        path = "/", 
                                        secure = self._request:is_https_protocol(),
                                        samesite = "Strict",
                                        extension = payload.csrf_token,
                                        expires = ngx.cookie_time(payload.exp)
                                    }

                                    local ok, err = cookie:set(u_table.clone_merge(cookie_module, {
                                        key = rule_handle.ident_field,
                                        value = ident_val,
                                        httponly = true
                                    }))
                                    
                                    -- CSRF令牌
                                    cookie:set(u_table.clone_merge(cookie_module, {
                                        key = "csrf_token",
                                        value = payload.csrf_token,
                                        httponly = false
                                    }))
                                    
                                    body.dt = {}
                                else
                                    body.dt = { 
                                        csrf_token = payload.csrf_token
                                    }

                                    body.dt[rule_handle.ident_field] = ident_val
                                end
                            end

                            return ok, err, body
                        end, function ( api_print )
                            case_error_exit(api_print)
                        end)
                    elseif check_uri(rule_handle.ident_destory) then
                        local exit_model = ue_error.get_err(ident_event_code, "登出成功")
                        exit_model.res = true

                        if ident_is_ok then
                            load_api_exec("ident_destory", micro_req_url, {
                                server_name = server_name
                            }, ident_payload, function(body)
                                if not ident_payload.jti then
                                    return false, "服务器程序错误，未批对到相应的 payload.jti 不存在"
                                end

                                local ok, err = self._ident_cache:del(ident_secret)
                                return ok, err, (ok and body) or exit_model
                            end, function ( api_print )
                                case_error_exit(api_print)
                            end)
                        else
                            case_error_exit(exit_model)
                        end
                    elseif check_uri(rule_handle.ctrl_open) or check_uri(rule_handle.ctrl_pass) then
                        case_error_exit(ue_error.get_err(self.utils.ex.error.EVENT_CODE.illegal))
                    end

                    return false
                end
            end)
            
            -- ***???变量提取貌似存在问题
            -- local handle = rule.handle
            -- local extractor_type = rule.extractor.type
            -- local rewrite_uri = u_handle.build_uri(extractor_type, handle.uri_tmpl, variables)
            
            -- 流程3：改写路径为子系统的URI（仅在匹配为访问子系统时，才进行接口验证，否则走默认通道（前端））
            if micro_uri then
                -- 加载变量数据
                local load_micro_url = function ( var )
                    local match = u_string.match_wrape_with(var, "{", "}")
                    if not match then
                        return var
                    end

                    local server_node = rule_handle.server_nodes[match]
                    if not server_node then
                        case_error_exit(ue_error.get_err(self.utils.ex.error.EVENT_CODE.program_err, s_format("can not find the server_node of '%s' in cache, please sure it exists", var)))
                    end
                    
                    local server_node_var = s_format("{%s}", match)                
                    return s_gsub(var, server_node_var, server_node.server_url)
                end

                -- 如果是开放接口
                local ctrl_args = { uri = uri, uri_args = uri_args, http_method = http_method, server_name = server_name }
                load_api_exec("ctrl_open", load_micro_url(rule_handle.ctrl_open), ctrl_args, ident_payload, nil, function(open_print)
                    if ident_is_ok then
                        -- 非开放接口时，才会验证是否为鉴权接口
                        load_api_exec("ctrl_pass", load_micro_url(rule_handle.ctrl_pass), ctrl_args, ident_payload, nil, function(pass_print)
                            return pass_print.res, pass_print.msg, ue_error.get_err(self.utils.ex.error.EVENT_CODE.unauthorized)
                        end)
                    else
                        -- 会话超时的情况
                        return open_print.res, open_print.msg, ue_error.get_err(ident_event_code)
                    end
                end, true)
                
                -- 只有在需要请求下游系统时，且JWT-OK，才会在header中追加payload参数
                n_var.upstream_payload = self.utils.json.encode(ident_payload)

                -- 重写URI，没有的情况下，不进行重写
                ngx.req.set_uri(micro_uri)
                
                self:rule_log_info(rule, s_format("[server-rewrite:{%s}] server_host: %s, server_url: %s, rewrite_uri: %s, rewrite_uri_args: %s", uri, micro_host, micro_url, micro_uri, micro_uri_args))
            else
                micro_uri = s_gsub(uri, rule_matched, "")
                if not u_object.check(micro_uri) then
                    micro_uri = "/"
                end

                -- 重写URI，没有的情况下，不进行重写
                ngx.req.set_uri(micro_uri)
            end
        end

        -- 反向代理设置           
        local extractor_type = rule.extractor.type
        if not u_object.check(micro_host) then -- host默认取请求的host
            n_var.upstream_host = n_var.host
        else 
            n_var.upstream_host = u_handle.build_upstream_host(extractor_type, micro_host, variables, self._name)
        end

        n_var.upstream_url = u_handle.build_upstream_url(extractor_type, micro_url, variables, self._name)
        self:rule_log_debug(rule, s_format("[%s-match-micro-server:upstream] %s -> extractor_type: %s, upstream_host: %s, upstream_url: %s", self._name, rule.name, extractor_type, n_var.upstream_host, n_var.upstream_url))
    end

    self:exec_action(rule_pass_func)
end

function handler:access()
    -- n_log(n_err, "load exec access")
end

function handler:header_filter()
    ngx.header.payload = nil
end

function handler:body_filter()
    -- n_log(n_err, "load exec header_filter")
end

function handler:log()
    -- n_log(n_err, "load exec log")
end

--------------------------------------------------------------------------
return handler