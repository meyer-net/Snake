(function (L) {
    var _this = null;
    L.TmplVars = L.TmplVars || {};
    _this = L.TmplVars = {
        data: {},

        init: function () {
            L.Common.loadConfigs("tmpl_vars", _this, true);
            _this.initEvents();
        },

        initEvents: function () {
            L.Common.initRuleAddDialog("tmpl_vars", _this); //添加规则对话框
            L.Common.initRuleDeleteDialog("tmpl_vars", _this); //删除规则对话框
            L.Common.initRuleEditDialog("tmpl_vars", _this); //编辑规则对话框
            L.Common.initRuleSortEvent("tmpl_vars", _this);

            L.Common.initSelectorAddDialog("tmpl_vars", _this);
            L.Common.initSelectorDeleteDialog("tmpl_vars", _this);
            L.Common.initSelectorEditDialog("tmpl_vars", _this);
            L.Common.initSelectorSortEvent("tmpl_vars", _this);
            L.Common.initSelectorClickEvent("tmpl_vars", _this);

            L.Common.initSelectorTypeChangeEvent(); //选择器类型选择事件
            L.Common.initConditionAddOrRemove(); //添加或删除条件
            L.Common.initJudgeTypeChangeEvent(); //judge类型选择事件
            L.Common.initConditionTypeChangeEvent(); //condition类型选择事件

            L.Common.initExtractionAddOrRemove(); //添加或删除条件
            L.Common.initExtractionTypeChangeEvent(); //extraction类型选择事件
            L.Common.initExtractionAddBtnEvent(); //添加提前项按钮事件
            L.Common.initExtractionHasDefaultValueOrNotEvent(); //提取项是否有默认值选择事件

            L.Common.initViewAndDownloadEvent("tmpl_vars", _this);
            L.Common.initSwitchBtn("tmpl_vars", _this); //redirect关闭、开启
            L.Common.initSyncDialog("tmpl_vars", _this); //编辑规则对话框
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
            var handle = {
                tmpl_vars: []
            };

            $("#pair-area").find(".pair-holder").each(function () {
                var pair_key = $(this).find(".pair-key-hodler input").val();
                var pair_value = $(this).find(".pair-value-hodler input").val();

                if (pair_key) {
                    handle.tmpl_vars.push({
                        key: pair_key,
                        value: pair_value
                    })
                }
            })

            if (handle.tmpl_vars.length == 0) {
                result.success = false;
                result.data = "未检查到有效的模板变量，请确认输入是否有误";
                return result;
            }

            var string_continue = $("#rule-continue").val()
            var int_continue = parseInt(string_continue)
            if (isNaN(int_continue)) {
                handle.continue = string_continue === "true";
            } else {
                handle.continue = int_continue
            }
            handle.log = ($("#rule-handle-log").val() === "true");
            result.success = true;
            result.handle = handle;
            return result;
        },
    };
}(APP));