(function (L) {
    var _this = null;
    L.Micros = L.Micros || {};
    _this = L.Micros = {
        data: {},

        init: function () {
            L.Common.loadConfigs("micros", _this, true);
            _this.initEvents();
        },

        initEvents: function () {
            // console.log(111);
            var op_type = "micros";
            L.Common.initRuleAddDialog(op_type, _this); //添加规则对话框
            L.Common.initRuleDeleteDialog(op_type, _this); //删除规则对话框
            L.Common.initRuleEditDialog(op_type, _this); //编辑规则对话框
            L.Common.initRuleSortEvent(op_type, _this);

            L.Common.initSelectorAddDialog(op_type, _this);
            L.Common.initSelectorDeleteDialog(op_type, _this);
            L.Common.initSelectorEditDialog(op_type, _this);
            L.Common.initSelectorSortEvent(op_type, _this);
            L.Common.initSelectorClickEvent(op_type, _this);

            L.Common.initViewAndDownloadEvent(op_type, _this);
            L.Common.initSwitchBtn(op_type, _this); //redirect关闭、开启
            L.Common.initSyncDialog(op_type, _this); //编辑规则对话框
        },


        buildRule: function () {
            var result = {
                success: false,
                data: {
                    name: null,
                    key: null,
                    open: 0,
                    handle: {}
                }
            };

            //build name and judge
            var buildJudgeResult = L.Common.buildJudge();
            if (buildJudgeResult.success == true) {
                result.data.name = buildJudgeResult.data.name;
                result.data.key = buildJudgeResult.data.key;
            } else {
                result.success = false;
                result.data = buildJudgeResult.data;
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

            //build handle
            var elem_open = $("#rule-open");
            if (elem_open.length > 0) {
                result.data.open = elem_open.val();
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

            var host = $("#rule-host").val();
            handle.host = host;

            var url = $("#rule-url").val();
            if (!url) {
                result.success = false;
                result.data = "服务URL地址不得为空";
                $("#rule-url").focus()
                return result;
            }
            handle.url = url;

            handle.log = ($("#rule-handle-log").val() === "true");
            result.success = true;
            result.handle = handle;
            return result;
        },
    };
}(APP));