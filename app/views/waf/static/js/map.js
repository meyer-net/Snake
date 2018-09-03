(function (L) {
    var _this = null;
    L.Map = L.Map || {};
    _this = L.Map = {
        data: {},

        init: function () {
            L.Common.loadConfigs("map", _this, true);
            _this.initEvents();
        },

        findApi: function (active_plugin) {
            var selected_plugin = active_plugin || $("#add-plugin-select option:selected").val();
            if (selected_plugin && selected_plugin.length > 0) {
                var object_name = selected_plugin.substring(0, 1).toUpperCase() + selected_plugin.substring(1);
                return L[object_name];
            }
        },

        initEvents: function () {
            L.Common.initRuleAddDialog("map", _this); //添加规则对话框
            L.Common.initRuleDeleteDialog("map", _this); //删除规则对话框
            L.Common.initRuleEditDialog("map", _this); //编辑规则对话框
            L.Common.initRuleSortEvent("map", _this);

            L.Common.initSelectorAddDialog("map", _this);
            L.Common.initSelectorDeleteDialog("map", _this);
            L.Common.initSelectorEditDialog("map", _this);
            L.Common.initSelectorSortEvent("map", _this);
            L.Common.initSelectorClickEvent("map", _this);

            L.Common.initSelectorTypeChangeEvent(); //选择器类型选择事件
            L.Common.initConditionAddOrRemove(); //添加或删除条件
            L.Common.initJudgeTypeChangeEvent(); //judge类型选择事件
            L.Common.initConditionTypeChangeEvent(); //condition类型选择事件

            L.Common.initExtractionAddOrRemove(); //添加或删除条件
            L.Common.initExtractionTypeChangeEvent(); //extraction类型选择事件
            L.Common.initExtractionAddBtnEvent(); //添加提前项按钮事件
            L.Common.initExtractionHasDefaultValueOrNotEvent(); //提取项是否有默认值选择事件

            L.Common.initViewAndDownloadEvent("map", _this);
            L.Common.initSwitchBtn("map", _this); //redirect关闭、开启
            L.Common.initSyncDialog("map", _this); //编辑规则对话框
        },


        buildRule: function (active_plugin) {
            var rule = L.Map.findApi(active_plugin).buildRule();
            if (rule.success) {
                rule.data.plugin = active_plugin || $("#add-plugin-select option:selected").val()
            }
            return rule;
        }
    };
}(APP));