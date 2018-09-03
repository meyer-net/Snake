(function (L) {
    var _this = null;
    L.Capture = L.Capture || {};
    _this = L.Capture = {
        data: {},

        init: function () {
            L.Common.loadConfigs("capture", _this, true);
            _this.initEvents();
        },

        initEvents: function () {
            var op_type = "capture";
            L.Common.initRuleAddDialog(op_type, _this); //添加规则对话框
            L.Common.initRuleDeleteDialog(op_type, _this); //删除规则对话框
            L.Common.initRuleEditDialog(op_type, _this); //编辑规则对话框
            L.Common.initRuleSortEvent(op_type, _this);

            L.Common.initSelectorAddDialog(op_type, _this);
            L.Common.initSelectorDeleteDialog(op_type, _this);
            L.Common.initSelectorEditDialog(op_type, _this);
            L.Common.initSelectorSortEvent(op_type, _this);
            L.Common.initSelectorClickEvent(op_type, _this);

            L.Common.initSelectorTypeChangeEvent(); //选择器类型选择事件
            L.Common.initConditionAddOrRemove(); //添加或删除条件
            L.Common.initJudgeTypeChangeEvent(); //judge类型选择事件
            L.Common.initConditionTypeChangeEvent(); //condition类型选择事件

            L.Common.initExtractionAddOrRemove(); //添加或删除条件
            L.Common.initExtractionTypeChangeEvent(); //extraction类型选择事件
            L.Common.initExtractionAddBtnEvent(); //添加提前项按钮事件
            L.Common.initExtractionHasDefaultValueOrNotEvent(); //提取项是否有默认值选择事件

            L.Common.initViewAndDownloadEvent(op_type, _this);
            L.Common.initSwitchBtn(op_type, _this); //redirect关闭、开启
            L.Common.initSyncDialog(op_type, _this); //编辑规则对话框
        },


        buildRule: function () {
            var result = {
                success: false,
                data: {
                    name: null,
                    type: null,
                    judge: {}
                }
            };
            var handle = {};

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

            var handle_type = $("#rule-micro-type").val()

            if (handle_type == "0") {
                //build capture
                var host = $("#rule-host").val();
                // if (!host) {
                //     result.success = false;
                //     result.data = "capture host不得为空";
                //     return result;
                // }

                handle.host = host || "";

                var url = $("#rule-url").val();
                if (!url) {
                    result.success = false;
                    result.data = "capture url不得为空";
                    return result;
                }
                handle.url = url;
            } else {
                var micro = $("#rule-micros").val()
                if (!micro) {
                    result.success = false;
                    result.data = "未选择对应处理的服务";
                    return result;
                }
                handle.micro = micro;
            }

            var content_type = $("#rule-content-type").val();
            handle.content_type = content_type || "";

            result.data.type = parseInt(handle_type);
            var string_continue = $("#rule-continue").val()
            var int_continue = parseInt(string_continue)
            if (isNaN(int_continue)) {
                handle.continue = string_continue === "true";
            } else {
                handle.continue = int_continue
            }
            handle.log = ($("#rule-handle-log").val() === "true");

            //enable or not
            var enable = $('#rule-enable').is(':checked');
            result.data.enable = enable;

            result.success = true;
            result.data.handle = handle;
            return result;
        },
    };
}(APP));