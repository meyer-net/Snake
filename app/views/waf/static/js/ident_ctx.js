(function (L) {
    var _this = null;
    L.Divide = L.Divide || {};
    _this = L.Divide = {
        data: {
        },

        init: function () {
            L.Common.loadConfigs("ident_ctx", _this, true);
            _this.initEvents();
        },

        initEvents: function () {
            var op_type = "ident_ctx";
            L.Common.initRuleAddDialog(op_type, _this);//添加规则对话框
            L.Common.initRuleDeleteDialog(op_type, _this);//删除规则对话框
            L.Common.initRuleEditDialog(op_type, _this);//编辑规则对话框
            L.Common.initRuleSortEvent(op_type, _this);

            L.Common.initSelectorAddDialog(op_type, _this);
            L.Common.initSelectorDeleteDialog(op_type, _this);
            L.Common.initSelectorEditDialog(op_type, _this);
            L.Common.initSelectorSortEvent(op_type, _this);
            L.Common.initSelectorClickEvent(op_type, _this);

            L.Common.initSelectorTypeChangeEvent();//选择器类型选择事件
            L.Common.initConditionAddOrRemove();//添加或删除条件
            L.Common.initJudgeTypeChangeEvent();//judge类型选择事件
            L.Common.initConditionTypeChangeEvent();//condition类型选择事件

            L.Common.initExtractionAddOrRemove();//添加或删除条件
            L.Common.initExtractionTypeChangeEvent();//extraction类型选择事件
            L.Common.initExtractionAddBtnEvent();//添加提前项按钮事件
            L.Common.initExtractionHasDefaultValueOrNotEvent();//提取项是否有默认值选择事件

            L.Common.initViewAndDownloadEvent(op_type, _this);
            L.Common.initSwitchBtn(op_type, _this);//redirect关闭、开启
            L.Common.initSyncDialog(op_type, _this);//编辑规则对话框
        },


        buildRule: function () {
            var result = {
                success: false,
                data: {
                    name: null,
                    judge: {},
                    extractor: {},
                    handle: {}
                }
            };

            //build name and judge
            var buildJudgeResult = L.Common.buildJudge();
            if (buildJudgeResult.success == true) {
                result.data.name = buildJudgeResult.data.name;
                result.data.judge = buildJudgeResult.data.judge;
            } else {
                result.success = false;
                result.data = buildJudgeResult.data;
                return result;
            }

            //build extractor
            var buildExtractorResult = L.Common.buildExtractor();
            if (buildExtractorResult.success == true) {
                result.data.extractor = buildExtractorResult.data.extractor;
            } else {
                result.success = false;
                result.data = buildExtractorResult.data;
                return result;
            }

            //build handle
            var buildHandleResult = _this.buildHandle();
            if (buildHandleResult.success == true) {
                result.data.handle = buildHandleResult.handle;
            } else {
                result.success = false;
                result.data = buildHandleResult.data;
                return result;
            }

            //enable or not
            var enable = $('#rule-enable').is(':checked');
            result.data.enable = enable;

            result.success = true;
            return result;
        },

        buildHandle: function () {
            var result = {};
            var handle = {};
            
            var default_host = $("#rule-default-host").val();
            handle.default_host = default_host || "127.0.0.1";

            var default_server = $("#rule-default-server").val();
            if (!default_server) {
                result.success = false;
                result.data = "默认服务URL地址不得为空";
                $("#rule-default-server").focus()
                return result;
            }
            handle.default_server = default_server;

            // var server_uri = $("#rule-server-uri").val();
            // if (!server_uri) {
            //     result.success = false;
            //     result.data = "默认服务URI不得为空";
            //     $("#rule-server-uri").focus();
            //     return result;
            // }
            // handle.server_uri = server_uri;

            handle.ignore_static = ($("#rule-ignore-static").is(':checked'));
            handle.ident_cookie = ($("#rule-ident-cookie").is(':checked'));

            var ident_field = $("#rule-ident-field").val();
            handle.ident_field = ident_field || "jwt";

            var ident_from = $("#rule-ident-from").val();
            if (!ident_from) {
                result.success = false;
                result.data = "鉴权信息来源接口地址不得为空";
                $("#rule-ident-from").focus();
                return result;
            }
            handle.ident_from = ident_from;

            var ident_destory = $("#rule-ident-destory").val();
            if (!ident_destory) {
                result.success = false;
                result.data = "鉴权信息销毁接口地址不得为空";
                $("#rule-ident-destory").focus();
                return result;
            }
            handle.ident_destory = ident_destory;

            var ctrl_open = $("#rule-ctrl-open").val();
            if (!ctrl_open) {
                result.success = false;
                result.data = "验证开放接口地址不得为空";
                $("#rule-ctrl-open").focus();
                return result;
            }
            handle.ctrl_open = ctrl_open;

            var ctrl_pass = $("#rule-ctrl-pass").val();
            if (!ctrl_pass) {
                result.success = false;
                result.data = "验证鉴权接口地址不得为空";
                $("#rule-ctrl-pass").focus();
                return result;
            }
            handle.ctrl_pass = ctrl_pass;

            var server_nodes = $("#rule-server-nodes").val();
            if (!server_nodes) {
                result.success = false;
                result.data = "下游服务节点地址不得为空";
                $("#rule-server-nodes").focus();
                return result;
            }
            handle.server_nodes = JSON.parse(server_nodes);

            handle.log = ($("#rule-handle-log").val() === "true");
            result.success = true;
            result.handle = handle;
            return result;
        },
    };
}(APP));
