(function (L) {
    var _this = null;
    L.Common = L.Common || {};
    _this = L.Common = {
        data: {},

        findTemplate: function (selectors, plugin) {
            var selected_plugin = plugin || $("#add-plugin-select option:selected").val();
            if (selected_plugin && selected_plugin.length > 0) {
                var template = $("#map-rule-" + selected_plugin)
                if (template.length > 0) {
                    return template.find(selectors)
                }
            }

            return $(selectors);
        },

        findTemplateHtml: function (selectors, rule, action) {
            var tpl = _this.findTemplate(selectors, rule.plugin).html();

            return juicer(tpl, action(rule));
        },

        findTemplateHtmls: function (selectors, rules, action) {
            var html = "";
            for (ruleIndex in rules) {
                var rule = rules[ruleIndex];
                var tpl = _this.findTemplate(selectors, rule.plugin).html();

                html = html.concat(_this.findTemplateHtml(selectors, rule, action));
            }

            return html;
        },

        init: function () {
            $(document).ready(function () {
                var start_plugin = false;
                $("#side-menu li").each(function () {
                    var li = $(this);
                    var span = li.find("span");
                    var link = li.find("a");

                    if (span.text() == "插件") {
                        start_plugin = true;
                        return true;
                    }

                    if (span.length <= 0) {
                        return false;
                    }

                    if (start_plugin) {
                        $("#add-plugin-select select").append("<option value='" + link.attr("href").substring(1) + "'>" + span.text() + "</option>");
                    }
                });

                function replace_place(text) {
                    return text.replace(new RegExp('{!t_name!}', 'gim'), global_settings.t_name)
                        .replace(new RegExp('{!c_name!}', 'gim'), global_settings.c_name)
                        .replace(new RegExp('{!g_name!}', 'gim'), global_settings.g_name);
                }

                $('.replace').each(function () {
                    var element = $(this);
                    var text = replace_place(element.text());
                    element.replaceWith(text);
                });

                $('select option').each(function () {
                    var element = $(this);
                    var text = replace_place(element.text());
                    element.text(text);
                });

                $('script').each(function () {
                    var element = $(this);
                    var text = replace_place(element.text());
                    element.text(text);
                });

            });
        },

        //增加、删除条件按钮事件
        initConditionAddOrRemove: function () {
            //添加规则框里的事件
            //点击“加号“添加新的输入行
            $(document).on('click', '#judge-area .pair .btn-add', _this.addNewCondition);

            //删除输入行
            $(document).on('click', '#judge-area .pair .btn-remove', function (event) {
                $(this).parents('.form-group').remove(); //删除本行输入
                _this.resetAddConditionBtn();
            });
        },

        //变量提取器增加、删除按钮事件
        initExtractionAddOrRemove: function () {

            //添加规则框里的事件
            //点击“加号“添加新的输入行
            $(document).on('click', '#extractor-area .pair .btn-add', _this.addNewExtraction);

            //删除输入行
            $(document).on('click', '#extractor-area .pair .btn-remove', function (event) {
                $(this).parents('.form-group').remove(); //删除本行输入
                _this.resetAddExtractionBtn();
            });
        },

        initExtractionAddBtnEvent: function () {
            $(document).on('click', '#add-extraction-btn', function () {
                var row;
                var current_es = $('.extraction-holder');
                if (current_es && current_es.length) {
                    row = current_es[current_es.length - 1];
                }
                if (row) { //至少存在了一个提取项
                    var new_row = $(row).clone(true);

                    var old_type = $(row).find("select[name=rule-extractor-extraction-type]").val();
                    $(new_row).find("select[name=rule-extractor-extraction-type]").val(old_type);
                    $(new_row).find("label").text("");

                    $("#extractor-area").append($(new_row));
                } else { //没有任何提取项，从模板创建一个
                    var html = $("#single-extraction-tmpl").html();
                    $("#extractor-area").append(html);
                }

                _this.resetAddExtractionBtn();
            });
        },

        //变量提取器增加、删除按钮事件
        initPairAddOrRemove: function (id) {
            //添加规则框里的事件
            //点击“加号“添加新的输入行
            $('#' + id + ' .btn-add').unbind("click").on('click', function (event) {
                _this.addNewPair(this, id);
            });

            //删除输入行
            $('#' + id + ' .btn-remove').unbind("click").on('click', function (event) {
                $(this).parents('.form-group').remove(); //删除本行输入
                _this.resetAddFilterBtn(id);
            });
        },

        //selector类型选择事件
        initSelectorTypeChangeEvent: function () {
            $(document).on("change", '#' + global_settings.i_key + '-type', function () {
                var selector_type = $(this).val();
                if (selector_type == "1") {
                    $("#judge-area").show();
                } else {
                    $("#judge-area").hide();
                }
            });
        },

        //judge类型选择事件
        initJudgeTypeChangeEvent: function () {
            $(document).on("change", '#rule-judge-type', function () {
                var judge_type = $(this).val();
                if (judge_type != "0" && judge_type != "1" && judge_type != "2" && judge_type != "3") {
                    L.Common.showTipDialog("提示", "选择的judge类型不合法");
                    return
                }

                if (judge_type == "3") {
                    $("#expression-area").show();
                } else {
                    $("#expression-area").hide();
                }
            });
        },

        //condition类型选择事件
        initConditionTypeChangeEvent: function () {
            $(document).on("change", 'select[name=rule-judge-condition-type]', function () {
                var condition_type = $(this).val();

                if (condition_type != "Header" && condition_type != "Query" && condition_type != "PostParams") {
                    $(this).parents(".condition-holder").each(function () {
                        $(this).find(".condition-name-hodler").hide();
                    });
                } else {
                    $(this).parents(".condition-holder").each(function () {
                        $(this).find(".condition-name-hodler").show();
                    });
                }
            });
        },

        //micro类型选择事件
        initMicroTypeChangeEvent: function () {
            var rule_micro_type_selector = 'select[id=rule-micro-type]';
            $(rule_micro_type_selector).unbind("change").on("change", function () {
                var micro_type = $(this).val();
                var parents = $(this).parents("#micro-holder")
                var elem_micro_define = parents.find("#micro-define")
                var elem_micro_area = parents.find("#micro-area")
                if (micro_type == "0") {
                    elem_micro_define.show();
                    elem_micro_area.hide();
                } else {
                    elem_micro_define.hide();
                    elem_micro_area.show();
                    var rule_micro_group_id = "select[id=rule-micro-group]";
                    var elem_rule_micro_group = elem_micro_area.find(rule_micro_group_id)

                    $.ajax({
                        url: '/micros/selectors',
                        type: 'get',
                        cache: false,
                        dataType: 'json',
                        success: function (result) {
                            if (result.success) {
                                elem_rule_micro_group.empty();
                                _this.renderToSelectBySelectors(rule_micro_group_id, result.data.selectors);

                                var selectors_keys = Object.keys(result.data.selectors);
                                if (selectors_keys.length > 0) {
                                    var rule_micros_id = "select[id=rule-micros]";
                                    var elem_rule_micros = $(rule_micros_id);
                                    $(rule_micro_group_id).unbind("change").on("change", function (event, bind_func) {
                                        $.ajax({
                                            url: '/micros/selectors/' + elem_rule_micro_group.val() + '/rules',
                                            type: 'get',
                                            cache: false,
                                            dataType: 'json',
                                            success: function (result) {
                                                if (result.success) {
                                                    elem_rule_micros.empty();
                                                    _this.renderToSelectBySelectors(rule_micros_id, result.data.rules);
                                                    if (bind_func) {
                                                        bind_func();
                                                    }
                                                    return true;
                                                } else {
                                                    L.Common.showErrorTip("提示", result.msg || "获取服务列表发生错误");
                                                    return false;
                                                }
                                            },
                                            error: function () {
                                                L.Common.showErrorTip("提示", "获取服务列表请求发生异常");
                                                return false;
                                            }
                                        });
                                    });

                                    var actived_micro = elem_micro_area.attr("actived-micro");
                                    if (actived_micro) {
                                        function timeout(ms) {
                                            return new Promise((resolve) => {
                                                setTimeout(resolve, ms);
                                            });
                                        }

                                        var finded = false;
                                        var prev_doing = false;
                                        var load = async function (key) {
                                            prev_doing = true;
                                            elem_rule_micro_group.find("option").removeAttr("selected");
                                            elem_rule_micro_group.find("option[value='" + key + "']").attr("selected", "selected");
                                            elem_rule_micro_group.trigger("change", function () {
                                                var elem_rule_micros_selected = elem_rule_micros.find("option[value='" + actived_micro + "']");
                                                if (elem_rule_micros_selected.length > 0) {
                                                    elem_rule_micros.find("option").removeAttr("selected");
                                                    elem_rule_micros_selected.attr("selected", "selected");

                                                    finded = true;
                                                    prev_doing = false;
                                                    return;
                                                }

                                                prev_doing = false;
                                            });
                                        }

                                        async function dbFuc() {
                                            for (let key of selectors_keys) {
                                                await load(key);
                                                while (prev_doing) {
                                                    await timeout(1)
                                                }
                                                if (finded) {
                                                    return;
                                                }
                                            }
                                        }

                                        dbFuc()
                                    } else {
                                        elem_rule_micro_group.trigger("change");
                                    }
                                }

                                return true;
                            } else {
                                L.Common.showErrorTip("提示", result.msg || "获取服务组发生错误");
                                return false;
                            }
                        },
                        error: function () {
                            L.Common.showErrorTip("提示", "获取服务组请求发生异常");
                            return false;
                        }
                    });
                }
            });
            $(rule_micro_type_selector).trigger("change");
        },

        //提取项是否有默认值选择事件
        initExtractionHasDefaultValueOrNotEvent: function () {
            $(document).on("change", 'select[name=rule-extractor-extraction-has-default]', function () {
                var has_default = $(this).val();

                if (has_default == "1") {
                    $(this).parents(".extraction-default-hodler").each(function () {
                        $(this).find("div[name=rule-extractor-extraction-default]").show();
                    });
                } else {
                    $(this).parents(".extraction-default-hodler").each(function () {
                        $(this).find("div[name=rule-extractor-extraction-default]").hide();
                    });
                }
            });
        },

        initExtractionTypeChangeEvent: function () {
            $(document).on("change", 'select[name=rule-extractor-extraction-type]', function () {
                var extraction_type = $(this).val();

                if (extraction_type != "Header" && extraction_type != "Query" &&
                    extraction_type != "PostParams" && extraction_type != "URI") {
                    $(this).parents(".extraction-holder").each(function () {
                        $(this).find(".extraction-name-hodler").hide();
                    });
                } else {
                    $(this).parents(".extraction-holder").each(function () {
                        $(this).find(".extraction-name-hodler").show();
                    });
                }

                //URI类型没有默认值选项
                if (extraction_type == "URI") {
                    $(this).parents(".extraction-holder").each(function () {
                        $(this).find("select[name=rule-extractor-extraction-has-default]").hide();
                        $(this).find("div[name=rule-extractor-extraction-default]").hide();
                    });
                } else {
                    $(this).parents(".extraction-holder").each(function () {
                        $(this).find("select[name=rule-extractor-extraction-has-default]").val("0").show();
                        $(this).find("div[name=rule-extractor-extraction-default]").hide();
                    });
                }
            });
        },

        initPairTypeChangeEvent: function () {
            $(document).on("change", 'select[name=rule-pair-type]', function () {
                var filter_type = $(this).val();

                if (filter_type == "0") {
                    $(this).parents(".pair-holder").each(function () {
                        $(this).find(".filter-key-hodler").show();
                        $(this).find(".filter-value-hodler").show();
                        $(this).find("select[name=rule-pair-body]").hide();
                    });
                } else if (filter_type == "1") {
                    // console.log(1111);
                    $(this).parents(".pair-holder").each(function () {
                        $(this).find(".filter-key-hodler").hide();
                        $(this).find(".filter-value-hodler").hide();
                        $(this).find("select[name=rule-pair-body]").show();
                    });
                }
            });
        },

        buildSelector: function () {
            var result = {
                success: false,
                data: {
                    name: null,
                    key: null,
                    open: null,
                    type: 0,
                    judge: {},
                    handle: {}
                }
            };

            // build name
            var name = $("#selector-name").val();
            if (!name) {
                result.success = false;
                result.data = "名称不能为空";
                return result;
            }
            result.data.name = name;

            // build name
            var elem_key = $("#selector-key")
            if (elem_key.length > 0) {
                var key = elem_key.val();
                if (!key) {
                    result.success = false;
                    result.data = "标记不能为空";
                    return result;
                }
                result.data.key = key;
            } else {
                delete result.data.key
            }

            // build type
            var elem_type = $("#selector-type");
            if (elem_type.length > 0) {
                var type = elem_type.val();
                if (!type) {
                    result.success = false;
                    result.data = "类型不能为空";
                    return result;
                }
                result.data.type = parseInt(type);

                //build judge
                if (type == 1) {
                    var buildJudgeResult = L.Common.buildJudge(true);
                    if (buildJudgeResult.success == true) {
                        result.data.judge = buildJudgeResult.data.judge;
                    } else {
                        result.success = false;
                        result.data = buildJudgeResult.data;
                        return result;
                    }
                }
            } else {
                delete result.data.judge
                delete result.data.type
            }

            //build handle
            var string_continue = $("#selector-continue").val();
            var int_continue = parseInt(string_continue);
            if (isNaN(int_continue)) {
                result.data.handle.continue = string_continue === "true";
            } else {
                result.data.handle.continue = int_continue
            }

            //build handle
            var elem_open = $("#selector-open");
            if (elem_open.length > 0) {
                result.data.open = elem_open.val();
            } else {
                delete result.data.open
            }

            result.data.handle.log = ($("#selector-log").val() === "true"); 

            //enable or not
            var enable = $('#' + global_settings.i_key + '-enable').is(':checked');
            result.data.enable = enable;

            result.success = true;
            return result;
        },

        buildName: function () {
            var result = {
                success: false,
                data: {
                    name: {}
                }
            };

            var name = $("#rule-name").val();
            if (!name) {
                result.data = global_settings.c_name + "名称不能为空";
                return result;
            }

            result.data.name = name;
            result.success = true;
            return result;
        },

        buildKey: function () {
            var result = {
                success: false,
                data: {
                    key: {}
                }
            };

            var elem_key = $("#rule-key")
            var key = elem_key.val();
            if (elem_key.length > 0 && !key) {
                result.data = global_settings.c_name + "标记不能为空";
                return result;
            }

            result.data.key = key;
            result.success = true;
            return result;
        },

        buildJudge: function (ignore_name) {
            var result = {
                success: false,
                data: {
                    judge: {}
                }
            };

            if (ignore_name != true) {
                var temp_result = L.Common.buildName();
                if (!temp_result.success) {
                    return temp_result;
                } else {
                    result.data.name = temp_result.data.name
                }
            }

            var temp_result = L.Common.buildKey();
            if (!temp_result.success) {
                return temp_result;
            } else {
                result.data.key = temp_result.data.key
            }

            var judge_type = parseInt($("#rule-judge-type").val());
            result.data.judge.type = judge_type;

            if (judge_type == 3) {
                var judge_expression = $("#rule-judge-expression").val();
                if (!judge_expression) {
                    result.success = false;
                    result.data = "复杂匹配的" + global_settings.c_name + "表达式不得为空";
                    return result;
                }
                result.data.judge.expression = judge_expression;
            }

            var elem_condition = $(".condition-holder")
            if (elem_condition.length > 0) {
                var judge_conditions = [];

                var tmp_success = true;
                var tmp_tip = "";
                elem_condition.each(function () {
                    var self = $(this);
                    var condition = {};
                    var condition_type = self.find("select[name=rule-judge-condition-type]").val();
                    condition.type = condition_type;

                    if (condition_type == "Header" || condition_type == "Query" || condition_type == "PostParams") {
                        var condition_name = self.find("input[name=rule-judge-condition-name]").val();
                        if (!condition_name) {
                            tmp_success = false;
                            tmp_tip = "condition的name字段不得为空";
                        }

                        condition.name = condition_name;
                    }

                    condition.operator = self.find("select[name=rule-judge-condition-operator]").val();
                    condition.value = self.find("input[name=rule-judge-condition-value]").val() || "";

                    judge_conditions.push(condition);
                });

                if (!tmp_success) {
                    result.success = false;
                    result.data = tmp_tip;
                    return result;
                }

                result.data.judge.conditions = judge_conditions;

                //判断规则类型和条件个数是否匹配
                if (result.data.judge.conditions.length < 1) {
                    result.success = false;
                    result.data = "请配置" + global_settings.c_name + "条件";
                    return result;
                }
                if (result.data.judge.type == 0 && result.data.judge.conditions.length != 1) {
                    result.success = false;
                    result.data = "单一条件匹配模式只能有一条condition，请删除多余配置";
                    return result;
                }
                if (result.data.judge.type == 3) { //判断条件表达式与条件个数等
                    try {
                        var condition_count = result.data.judge.conditions.length;
                        var regrex1 = /(v\[[0-9]+\])/g;
                        var regrex2 = /([0-9]+)/g;
                        var expression_v_array = []; // 提取条件变量
                        expression_v_array = result.data.judge.expression.match(regrex1);
                        if (!expression_v_array || expression_v_array.length < 1) {
                            result.success = false;
                            result.data = global_settings.c_name + "表达式格式错误，请检查";
                            return result;
                        }

                        var expression_v_array_len = expression_v_array.length;
                        var max_v_index = 1;
                        for (var i = 0; i < expression_v_array_len; i++) {
                            var expression_v = expression_v_array[i];
                            var index_array = expression_v.match(regrex2);
                            if (!index_array || index_array.length < 1) {
                                result.success = false;
                                result.data = global_settings.c_name + "表达式中条件变量格式错误，请检查";
                                return result;
                            }

                            var var_index = parseInt(index_array[0]);
                            if (var_index > max_v_index) {
                                max_v_index = var_index;
                            }
                        }

                        if (condition_count < max_v_index) {
                            result.success = false;
                            result.data = global_settings.c_name + "表达式中的变量最大索引[" + max_v_index + "]与条件个数[" + condition_count + "]不相符，请检查";
                            return result;
                        }
                    } catch (e) {
                        result.success = false;
                        result.data = "条件表达式验证发生异常:" + e;
                        return result;
                    }
                }
            }

            result.success = true;
            return result;
        },

        buildExtractor: function () {
            var result = {
                success: false,
                data: {}
            };

            //提取器类型
            var elem_extractor = $("#rule-extractor-type")

            if (elem_extractor.length > 0) {
                result.data.extractor = {}
                var extractor_type = elem_extractor.val();
                try {
                    extractor_type = parseInt(extractor_type);
                    if (!extractor_type || extractor_type != 2) {
                        extractor_type = 1;
                    }
                } catch (e) {
                    extractor_type = 1;
                }


                //提取项
                var extractions = [];
                var tmp_success = true;
                var tmp_tip = "";
                $(".extraction-holder").each(function () {
                    var self = $(this);
                    var extraction = {};
                    var type = self.find("select[name=rule-extractor-extraction-type]").val();
                    extraction.type = type;

                    //如果允许子key则提取
                    if (type == "Header" || type == "Query" || type == "PostParams" || type == "URI") {
                        var name = self.find("input[name=rule-extractor-extraction-name]").val();
                        if (!name) {
                            tmp_success = false;
                            tmp_tip = "变量提取项的name字段不得为空";
                        }
                        extraction.name = name;
                    }

                    //如果允许默认值则提取
                    var allow_default = (type == "Header" || type == "Query" || type == "PostParams" || type == "Host" || type == "IP" || type == "Method");
                    var has_default = self.find("select[name=rule-extractor-extraction-has-default]").val();
                    if (allow_default && has_default == "1") { //只有允许提取&&有默认值的才取默认值
                        var default_value = self.find("div[name=rule-extractor-extraction-default]>input").val();
                        if (!default_value) {
                            default_value = "";
                        }
                        extraction.default = default_value;
                    }

                    extractions.push(extraction);
                });

                if (!tmp_success) {
                    result.success = false;
                    result.data = tmp_tip;
                    return result;
                }

                result.data.extractor.type = extractor_type;
                result.data.extractor.extractions = extractions;
            }
            result.success = true;
            return result;
        },

        showRulePreview: function (rule) {
            var content = "";

            if (rule.success == true) {
                content = '<pre id="preview_rule"><code></code></pre>';
            } else {
                content = rule.data;
            }

            var d = dialog({
                title: global_settings.c_name + '预览',
                width: 500,
                content: content,
                modal: true,
                button: [{
                    value: '返回',
                    callback: function () {
                        d.close().remove();
                    }
                }]
            });
            d.show();

            $("#preview_rule code").text(JSON.stringify(rule.data, null, 2));
            $('pre code').each(function () {
                hljs.highlightBlock($(this)[0]);
            });
        },

        addNewCondition: function (event) {
            var self = $(this);
            var row = self.parents('.condition-holder');
            var new_row = row.clone(true);
            // $(new_row).find("input[name=rule-judge-condition-value]").val("");
            // $(new_row).find("input[name=rule-judge-condition-name]").val("");

            var old_type = $(row).find("select[name=rule-judge-condition-type]").val();
            $(new_row).find("select[name=rule-judge-condition-type]").val(old_type);

            var old_operator = $(row).find("select[name=rule-judge-condition-operator]").val();
            $(new_row).find("select[name=rule-judge-condition-operator]").val(old_operator);

            $(new_row).insertAfter($(this).parents('.condition-holder'))
            _this.resetAddConditionBtn();
        },

        resetAddConditionBtn: function () {
            var l = $("#judge-area .pair").length;
            var c = 0;
            $("#judge-area .pair").each(function () {
                c++;
                if (c == l) {
                    $(this).find(".btn-add").show();
                    if (l != 1) {
                        $(this).find(".btn-remove").show();
                    } else {
                        $(this).find(".btn-remove").hide();
                    }
                } else {
                    $(this).find(".btn-add").hide();
                    $(this).find(".btn-remove").show();
                }
            })
        },

        addNewPair: function (event, id) {

            var self = $(event);
            var row = self.parents('.pair-holder');

            var new_row = row.clone(true);

            $(new_row).find("label").text("");

            $(new_row).insertAfter($(event).parents('.pair-holder'))
            _this.resetAddFilterBtn(id);
        },

        addNewExtraction: function (event) {
            var self = $(this);
            var row = self.parents('.extraction-holder');
            var new_row = row.clone(true);

            var old_type = $(row).find("select[name=rule-extractor-extraction-type]").val();
            $(new_row).find("select[name=rule-extractor-extraction-type]").val(old_type);

            var old_has_default_value = $(row).find("select[name=rule-extractor-extraction-has-default]").val();
            $(new_row).find("select[name=rule-extractor-extraction-has-default]").val(old_has_default_value);
            if (old_has_default_value == "1") {
                $(new_row).find("input[name=rule-extractor-extraction-default]").show().val("");
            } else {
                $(new_row).find("input[name=rule-extractor-extraction-default]").hide();
            }

            if (old_type == "URI") { //如果拷贝的是URI类型，则不显示default
                $(new_row).find("input[name=rule-extractor-extraction-default]").hide();
                $(new_row).find("select[name=rule-extractor-extraction-has-default]").hide();
            }

            $(new_row).find("label").text("");

            $(new_row).insertAfter($(this).parents('.extraction-holder'))
            _this.resetAddExtractionBtn();
        },

        resetAddExtractionBtn: function () {
            var l = $("#extractor-area .pair").length;
            var c = 0;
            $("#extractor-area .pair").each(function () {
                c++;
                if (c == l) {
                    $(this).find(".btn-add").show();
                    if (l != 1) {
                        $(this).find(".btn-remove").show();
                    } else {
                        $(this).find(".btn-remove").hide();
                    }
                } else {
                    $(this).find(".btn-add").hide();
                    $(this).find(".btn-remove").show();
                }
            })
        },

        resetAddFilterBtn: function (id) {
            var l = $("#" + id + " .pair-holder").length;
            var c = 0;
            $("#" + id + " .pair-holder").each(function () {
                c++;
                if (c == l) {
                    $(this).find(".btn-add").show();
                    if (l != 1) {
                        $(this).find(".btn-remove").show();
                    } else {
                        $(this).find(".btn-remove").hide();
                    }
                } else {
                    $(this).find(".btn-add").hide();
                    $(this).find(".btn-remove").show();
                }
            })
        },

        //数据/表格视图转换和下载事件
        initViewAndDownloadEvent: function (type, context) {
            var data = context.data;

            $("#view-btn").click(function () { //试图转换
                var self = $(this);
                var now_state = $(this).attr("data-type");
                if (now_state == "table") { //当前是表格视图，点击切换到数据视图
                    self.attr("data-type", "database");
                    self.find("i").removeClass("fa-database").addClass("fa-table");
                    self.find("span").text("表格视图");

                    var showData = {};
                    showData.enable = data.enable;
                    showData.selectors = data.selectors;
                    jsonformat.format(JSON.stringify(showData));
                    $("#jfContent_pre").text(JSON.stringify(showData, null, 4));
                    $('pre').each(function () {
                        hljs.highlightBlock($(this)[0]);
                    });
                    $("#table-view").hide();
                    $("#database-view").show();
                } else {
                    self.attr("data-type", "table");
                    self.find("i").removeClass("fa-table").addClass("fa-database");
                    self.find("span").text("数据视图");

                    $("#database-view").hide();
                    $("#table-view").show();
                }
            });

            $(document).on("click", "#btnDownload", function () { //规则json下载
                var downloadData = {};
                downloadData.enable = data.enable;
                downloadData.selectors = data.selectors;
                var blob = new Blob([JSON.stringify(downloadData, null, 4)], {
                    type: "text/plain;charset=utf-8"
                });
                saveAs(blob, "data.json");
            });

        },

        initSwitchBtn: function (type, context) {
            var op_type = type;

            $("#switch-btn").click(function () { //是否开启
                var self = $(this);
                var now_state = $(this).attr("data-on");
                if (now_state == "yes") { //当前是开启状态，点击则“关闭”
                    var d = dialog({
                        title: op_type + '设置',
                        width: 300,
                        content: "确定要关闭" + op_type + "吗？",
                        modal: true,
                        button: [{
                            value: '取消'
                        }, {
                            value: '确定',
                            autofocus: false,
                            callback: function () {
                                $.ajax({
                                    url: '/' + op_type + '/enable',
                                    type: 'post',
                                    cache: false,
                                    data: {
                                        enable: "0"
                                    },
                                    dataType: 'json',
                                    success: function (result) {
                                        if (result.success) {
                                            //重置按钮
                                            context.data.enable = false;
                                            self.attr("data-on", "no");
                                            self.removeClass("btn-danger").addClass("btn-info");
                                            self.find("i").removeClass("fa-pause").addClass("fa-play");
                                            self.find("span").text("启用该" + global_settings.t_name);

                                            return true;
                                        } else {
                                            L.Common.showErrorTip("提示", result.msg || "关闭" + op_type + "发生错误");
                                            return false;
                                        }
                                    },
                                    error: function () {
                                        L.Common.showErrorTip("提示", "关闭" + op_type + "请求发生异常");
                                        return false;
                                    }
                                });
                            }
                        }]
                    });
                    d.show();


                } else {
                    var d = dialog({
                        title: op_type + '设置',
                        width: 300,
                        content: "确定要开启" + op_type + "吗？",
                        modal: true,
                        button: [{
                            value: '取消'
                        }, {
                            value: '确定',
                            autofocus: false,
                            callback: function () {
                                $.ajax({
                                    url: '/' + op_type + '/enable',
                                    type: 'post',
                                    cache: false,
                                    data: {
                                        enable: "1"
                                    },
                                    dataType: 'json',
                                    success: function (result) {
                                        if (result.success) {
                                            context.data.enable = true;
                                            //重置按钮
                                            if (global_settings.t_name && global_settings.t_name.length > 0) {
                                                self.attr("data-on", "yes");
                                                self.removeClass("btn-info").addClass("btn-danger");
                                                self.find("i").removeClass("fa-play").addClass("fa-pause");
                                                self.find("span").text("停用该" + global_settings.t_name);
                                            } else {
                                                self.remove()
                                            }

                                            return true;
                                        } else {
                                            L.Common.showErrorTip("提示", result.msg || "开启" + op_type + "发生错误");
                                            return false;
                                        }
                                    },
                                    error: function () {
                                        L.Common.showErrorTip("提示", "开启" + op_type + "请求发生异常");
                                        return false;
                                    }
                                });
                            }
                        }]
                    });
                    d.show();
                }
            });
        },

        initRuleAddDialog: function (type, context) {
            var op_type = type;
            var rules_key = "rules";

            $("#add-plugin-select select").change(function () {
                var selected_plugin = $(this).find('option:selected').val();
                if (selected_plugin && selected_plugin.length > 0) {
                    if ($("#map-rule-" + selected_plugin).length <= 0) {
                        L.Common.showErrorTip("提示", "获取插件" + selected_plugin + "发生异常，请确认 {(rules/" + selected_plugin + ".html)} 是否存在或是否有添加到当前页面内!");
                        return
                    }
                    showAddDialog(selected_plugin);
                }
            });

            function showAddDialog(plugin) {
                var selector_id = $("#add-btn").attr("data-id");
                if (!selector_id) {
                    L.Common.showErrorTip("错误提示", "添加" + global_settings.c_name + "前请先选择【" + global_settings.g_name + "】!");
                    return;
                }
                var content = L.Common.findTemplate("#add-tpl").html()
                var d = dialog({
                    title: '添加' + (plugin || "") + global_settings.c_name,
                    width: 720,
                    content: content,
                    modal: true,
                    onshow: function () {
                        L.Common.initMicroTypeChangeEvent(); //condition类型选择事件
                        L.Common.initPairAddOrRemove('pair-area'); //添加或删除条件
                        L.Common.initPairAddOrRemove('filter-area'); //添加或删除条件
                        L.Common.initPairTypeChangeEvent(); //添加或删除条件
                        $('select[name=rule-pair-type]').trigger("change");
                    },
                    button: [{
                        value: '取消'
                    }, {
                        value: '预览',
                        autofocus: false,
                        callback: function () {
                            var rule = context.buildRule();
                            L.Common.showRulePreview(rule);
                            return false;
                        }
                    }, {
                        value: '确定',
                        autofocus: false,
                        callback: function () {
                            var result = context.buildRule();
                            if (result.success == true) {
                                $.ajax({
                                    url: '/' + op_type + '/selectors/' + selector_id + "/rules",
                                    type: 'post',
                                    data: {
                                        rule: JSON.stringify(result.data)
                                    },
                                    dataType: 'json',
                                    success: function (result) {
                                        if (result.success) {
                                            //重新渲染规则
                                            _this.loadRules(op_type, context, selector_id);
                                            _this.refreshConfigs(op_type, context);
                                            return true;
                                        } else {
                                            L.Common.showErrorTip("提示", result.msg || "添加" + global_settings.c_name + "发生错误");
                                            return false;
                                        }
                                    },
                                    error: function () {
                                        L.Common.showErrorTip("提示", "添加" + global_settings.c_name + "请求发生异常");
                                        return false;
                                    }
                                });

                            } else {
                                L.Common.showErrorTip("错误提示", result.data);
                                return false;
                            }
                        }
                    }]
                });

                L.Common.resetAddConditionBtn(); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('pair-area'); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('filter-area'); //删除增加按钮显示与否
                d.show();
            };



            $("#add-btn").click(function () {
                showAddDialog();
            });
        },

        initSyncDialog: function (type, context) {
            var op_type = type;
            var rules_key = "rules";

            $("#sync-btn").click(function () {
                $.ajax({
                    url: '/' + op_type + '/fetch_config',
                    type: 'get',
                    cache: false,
                    data: {},
                    dataType: 'json',
                    success: function (result) {
                        if (result.success) {
                            var d = dialog({
                                title: '确定要从存储中同步配置吗?',
                                width: 680,
                                content: '<pre id="preview_plugin_config"><code></code></pre>',
                                modal: true,
                                button: [{
                                    value: '取消'
                                }, {
                                    value: '确定同步',
                                    autofocus: false,
                                    callback: function () {
                                        $.ajax({
                                            url: '/' + op_type + '/sync',
                                            type: 'post',
                                            cache: false,
                                            data: {},
                                            dataType: 'json',
                                            success: function (r) {
                                                if (r.success) {
                                                    _this.loadConfigs(op_type, context);
                                                    return true;
                                                } else {
                                                    _this.showErrorTip("提示", r.msg || "同步配置发生错误");
                                                    return false;
                                                }
                                            },
                                            error: function () {
                                                _this.showErrorTip("提示", "同步配置请求发生异常");
                                                return false;
                                            }
                                        });
                                    }
                                }]
                            });
                            d.show();

                            $("#preview_plugin_config code").text(JSON.stringify(result.data, null, 2));
                            $('pre code').each(function () {
                                hljs.highlightBlock($(this)[0]);
                            });
                        } else {
                            L.Common.showErrorTip("提示", result.msg || "从存储中获取该插件配置发生错误");
                            return;
                        }
                    },
                    error: function () {
                        L.Common.showErrorTip("提示", "从存储中获取该插件配置请求发生异常");
                        return false;
                    }
                });

            });
        },

        initRuleEditDialog: function (type, context) {
            var op_type = type;

            $(document).on("click", ".edit-btn", function () {
                var selector_id = $("#add-btn").attr("data-id");
                var rule_id = $(this).attr("data-id");
                var active_plugin = $(this).attr("data-type");
                var rule = {};
                var rules = context.data.selector_rules[selector_id];

                for (var i = 0; i < rules.length; i++) {
                    var r = rules[i];
                    if (r.id == rule_id) {
                        if (r.handle && r.handle.server_nodes) {
                            r.handle.server_nodes_string = JSON.stringify(r.handle.server_nodes)
                        }
                        rule = r;
                        break;
                    }
                }
                if (!rule_id || !rule) {
                    L.Common.showErrorTip("提示", "要编辑的" + global_settings.c_name + "不存在或者查找出错");
                    return;
                }


                // var tpl = L.Common.findTemplate("#edit-tpl").html();
                var html = _this.findTemplateHtml("#edit-tpl", rule, function (rule) {
                    return {
                        r: rule
                    }
                });

                // var html = juicer(tpl, {
                //     r: rule
                // });

                var d = dialog({
                    title: "编辑" + (rule.plugin || "") + global_settings.c_name,
                    width: 680,
                    content: html,
                    modal: true,
                    onshow: function () {
                        L.Common.initMicroTypeChangeEvent(); //condition类型选择事件
                        L.Common.initPairAddOrRemove('pair-area'); //添加或删除条件
                        L.Common.initPairAddOrRemove('filter-area'); //添加或删除条件
                        L.Common.initPairTypeChangeEvent(); //添加或删除条件
                    },
                    button: [{
                        value: '取消'
                    }, {
                        value: '预览',
                        autofocus: false,
                        callback: function () {
                            var rule = context.buildRule(active_plugin);
                            L.Common.showRulePreview(rule);
                            return false;
                        }
                    }, {
                        value: '保存修改',
                        autofocus: false,
                        callback: function () {
                            var result = context.buildRule(active_plugin);
                            result.data.id = rule.id; //拼上要修改的id

                            if (result.success == true) {
                                $.ajax({
                                    url: '/' + op_type + '/selectors/' + selector_id + "/rules",
                                    type: 'put',
                                    data: {
                                        rule: JSON.stringify(result.data)
                                    },
                                    dataType: 'json',
                                    success: function (result) {
                                        if (result.success) {
                                            //重新渲染规则
                                            _this.loadRules(op_type, context, selector_id);
                                            return true;
                                        } else {
                                            L.Common.showErrorTip("提示", result.msg || "编辑" + global_settings.c_name + "发生错误");
                                            return false;
                                        }
                                    },
                                    error: function () {
                                        L.Common.showErrorTip("提示", "编辑" + global_settings.c_name + "请求发生异常");
                                        return false;
                                    }
                                });

                            } else {
                                L.Common.showErrorTip("错误提示", result.data);
                                return false;
                            }
                        }
                    }]
                });

                L.Common.resetAddConditionBtn(); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('pair-area'); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('filter-area'); //删除增加按钮显示与否
                L.Common.resetAddExtractionBtn();
                context.resetAddCredentialBtn && context.resetAddCredentialBtn();
                d.show();
            });
        },

        initRuleDeleteDialog: function (type, context) {
            var op_type = type;

            $(document).on("click", ".delete-btn", function () {
                var name = $(this).attr("data-name");
                var rule_id = $(this).attr("data-id");
                var selector_id = $("#add-btn").attr("data-id");

                var d = dialog({
                    title: '提示',
                    width: 480,
                    content: "确定要删除" + global_settings.c_name + "【" + name + "】吗？",
                    modal: true,
                    button: [{
                        value: '取消'
                    }, {
                        value: '确定',
                        autofocus: false,
                        callback: function () {
                            $.ajax({
                                url: '/' + op_type + '/selectors/' + selector_id + "/rules",
                                type: 'delete',
                                data: {
                                    rule_id: rule_id
                                },
                                dataType: 'json',
                                success: function (result) {
                                    if (result.success) {
                                        //重新渲染规则
                                        _this.loadRules(op_type, context, selector_id);
                                        _this.refreshConfigs(op_type, context); //刷新本地缓存
                                        return true;
                                    } else {
                                        L.Common.showErrorTip("提示", result.msg || "删除" + global_settings.c_name + "发生错误");
                                        return false;
                                    }
                                },
                                error: function () {
                                    L.Common.showErrorTip("提示", "删除" + global_settings.c_name + "请求发生异常");
                                    return false;
                                }
                            });
                        }
                    }]
                });

                d.show();
            });
        },

        initRuleSortEvent: function (type, context) {
            var op_type = type;
            $(document).on("click", "#rule-sort-btn", function () {
                var new_order = [];
                if ($("#rules li")) {
                    $("#rules li").each(function (item) {
                        new_order.push($(this).attr("data-id"));
                    });
                }

                var new_order_str = new_order.join(",");
                if (!new_order_str || new_order_str == "") {
                    L.Common.showErrorTip("提示", global_settings.c_name + "列表为空， 无需排序");
                    return;
                }

                var selector_id = $("#add-btn").attr("data-id");
                if (!selector_id || selector_id == "") {
                    L.Common.showErrorTip("提示", "操作异常， 未选中" + global_settings.g_name + "， 无法排序");
                    return;
                }

                var d = dialog({
                    title: "提示",
                    content: "确定要保存新的" + global_settings.c_name + "顺序吗？",
                    width: 350,
                    modal: true,
                    cancel: function () {},
                    cancelValue: "取消",
                    okValue: "确定",
                    ok: function () {
                        $.ajax({
                            url: '/' + op_type + '/selectors/' + selector_id + '/rules/order',
                            type: 'put',
                            data: {
                                order: new_order_str
                            },
                            dataType: 'json',
                            success: function (result) {
                                if (result.success) {
                                    //重新渲染规则
                                    _this.loadRules(op_type, context, selector_id);
                                    return true;
                                } else {
                                    L.Common.showErrorTip("提示", result.msg || "保存排序发生错误");
                                    return false;
                                }
                            },
                            error: function () {
                                L.Common.showErrorTip("提示", "保存排序请求发生异常");
                                return false;
                            }
                        });
                    }
                });
                d.show();
            });
        },

        initSelectorAddDialog: function (type, context) {
            var op_type = type;
            $("#add-selector-btn").click(function () {
                var current_selected_id;
                var current_selected_selector = $("#selector-list li.selected-selector");
                if (current_selected_selector) {
                    current_selected_id = $(current_selected_selector[0]).attr("data-id");
                }

                var content = $("#add-selector-tpl").html()
                var d = dialog({
                    title: '添加' + global_settings.g_name,
                    width: 720,
                    content: content,
                    modal: true,
                    button: [{
                        value: '取消'
                    }, {
                        value: '确定',
                        autofocus: false,
                        callback: function () {
                            var result = _this.buildSelector();
                            if (result.success) {
                                $.ajax({
                                    url: '/' + op_type + '/' + global_settings.i_key + 's',
                                    type: 'post',
                                    data: {
                                        selector: JSON.stringify(result.data)
                                    },
                                    dataType: 'json',
                                    success: function (result) {
                                        if (result.success) {
                                            //重新渲染
                                            _this.loadConfigs(op_type, context, false, function () {
                                                $("#selector-list li[data-id=" + current_selected_id + "]").addClass("selected-selector");
                                            });
                                            return true;
                                        } else {
                                            L.Common.showErrorTip("提示", result.msg || "添加" + global_settings.g_name + "发生错误");
                                            return false;
                                        }
                                    },
                                    error: function () {
                                        L.Common.showErrorTip("提示", "添加" + global_settings.g_name + "请求发生异常");
                                        return false;
                                    }
                                });

                            } else {
                                L.Common.showErrorTip("错误提示", result.data);
                                return false;
                            }
                        }
                    }]
                });
                L.Common.resetAddConditionBtn(); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('pair-area'); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('filter-area'); //删除增加按钮显示与否
                d.show();
            });
        },

        initSelectorDeleteDialog: function (type, context) {
            var op_type = type;
            $(document).on("click", ".delete-selector-btn", function (e) {
                e.stopPropagation(); // 阻止冒泡
                var name = $(this).attr("data-name");
                var selector_id = $(this).attr("data-id");
                if (!selector_id) {
                    L.Common.showErrorTip("提示", "参数错误，要删除的" + global_settings.g_name + "不存在！");
                    return;
                }

                var current_selected_id;
                var current_selected_selector = $("#selector-list li.selected-selector");
                if (current_selected_selector) {
                    current_selected_id = $(current_selected_selector[0]).attr("data-id");
                }

                var d = dialog({
                    title: '提示',
                    width: 480,
                    content: "确定要删除" + global_settings.g_name + "【" + name + "】吗? 删除" + global_settings.g_name + "将同时删除它的所有" + global_settings.c_name + "!",
                    modal: true,
                    button: [{
                        value: '取消'
                    }, {
                        value: '确定',
                        autofocus: false,
                        callback: function () {
                            $.ajax({
                                url: '/' + op_type + '/' + global_settings.i_key + 's',
                                type: 'delete',
                                data: {
                                    selector_id: selector_id
                                },
                                dataType: 'json',
                                success: function (result) {
                                    if (result.success) {
                                        //重新渲染规则
                                        _this.loadConfigs(op_type, context, false, function () {
                                            //删除的是原先选中的"+global_settings.g_name+", 重新选中第一个
                                            if (current_selected_id == selector_id) {
                                                var selector_list = $("#selector-list li");
                                                if (selector_list && selector_list.length > 0) {
                                                    $(selector_list[0]).click();
                                                } else {
                                                    _this.emptyRules();
                                                }
                                            } else {
                                                if (current_selected_id) {
                                                    $("#selector-list li[data-id=" + current_selected_id + "]").addClass("selected-selector");
                                                } else {
                                                    _this.emptyRules();
                                                }
                                            }
                                        });

                                        return true;
                                    } else {
                                        L.Common.showErrorTip("提示", result.msg || "删除" + global_settings.g_name + "发生错误");
                                        return false;
                                    }
                                },
                                error: function () {
                                    L.Common.showErrorTip("提示", "删除" + global_settings.g_name + "请求发生异常");
                                    return false;
                                }
                            });
                        }
                    }]
                });

                d.show();
            });
        },

        initSelectorEditDialog: function (type, context) {
            var op_type = type;

            $(document).on("click", ".edit-selector-btn", function (e) {
                e.stopPropagation(); // 阻止冒泡
                var tpl = $("#edit-selector-tpl").html();
                var selector_id = $(this).attr("data-id");
                var selectors = context.data.selectors;
                selector = selectors[selector_id];
                if (!selector_id || !selector) {
                    L.Common.showErrorTip("提示", "要编辑的" + global_settings.g_name + "不存在或者查找出错");
                    return;
                }

                var html = juicer(tpl, {
                    s: selector
                });

                var d = dialog({
                    title: "编辑" + global_settings.g_name + "",
                    width: 680,
                    content: html,
                    modal: true,
                    button: [{
                        value: '取消'
                    }, {
                        value: '预览',
                        autofocus: false,
                        callback: function () {
                            var s = _this.buildSelector();
                            L.Common.showRulePreview(s);
                            return false;
                        }
                    }, {
                        value: '保存修改',
                        autofocus: false,
                        callback: function () {
                            var result = _this.buildSelector();
                            result.data.id = selector.id; //拼上要修改的id
                            result.data.rules = selector.rules; //拼上已有的rules

                            if (result.success == true) {
                                $.ajax({
                                    url: '/' + op_type + '/' + global_settings.i_key + 's',
                                    type: 'put',
                                    data: {
                                        selector: JSON.stringify(result.data)
                                    },
                                    dataType: 'json',
                                    success: function (result) {
                                        if (result.success) {
                                            //重新渲染规则
                                            _this.loadConfigs(op_type, context);
                                            return true;
                                        } else {
                                            L.Common.showErrorTip("提示", result.msg || "编辑" + global_settings.g_name + "发生错误");
                                            return false;
                                        }
                                    },
                                    error: function () {
                                        L.Common.showErrorTip("提示", "编辑" + global_settings.g_name + "请求发生异常");
                                        return false;
                                    }
                                });

                            } else {
                                L.Common.showErrorTip("错误提示", result.data);
                                return false;
                            }
                        }
                    }]
                });

                L.Common.resetAddConditionBtn(); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('pair-area'); //删除增加按钮显示与否
                L.Common.resetAddFilterBtn('filter-area'); //删除增加按钮显示与否
                L.Common.resetAddExtractionBtn();
                d.show();
            });
        },

        initSelectorSortEvent: function (type, context) {
            var op_type = type;
            $(document).on("click", "#selector-sort-btn", function () {
                var new_order = [];
                if ($("#selector-list li")) {
                    $("#selector-list li").each(function (item) {
                        new_order.push($(this).attr("data-id"));
                    });
                }

                var new_order_str = new_order.join(",");
                if (!new_order_str || new_order_str == "") {
                    L.Common.showErrorTip("提示", global_settings.g_name + "列表为空， 无需排序");
                    return;
                }

                var current_selected_id;
                var current_selected_selector = $("#selector-list li.selected-selector");
                if (current_selected_selector) {
                    current_selected_id = $(current_selected_selector[0]).attr("data-id");
                }

                var d = dialog({
                    title: "提示",
                    content: "确定要保存新的" + global_settings.g_name + "顺序吗？",
                    width: 350,
                    modal: true,
                    cancel: function () {},
                    cancelValue: "取消",
                    okValue: "确定",
                    ok: function () {
                        $.ajax({
                            url: '/' + op_type + '/selectors/order',
                            type: 'put',
                            data: {
                                order: new_order_str
                            },
                            dataType: 'json',
                            success: function (result) {
                                if (result.success) {
                                    //重新渲染规则
                                    _this.loadConfigs(op_type, context, false, function () {
                                        if (current_selected_id) { //高亮原来选中的li
                                            $("#selector-list li[data-id=" + current_selected_id + "]").addClass("selected-selector");
                                        }
                                    });
                                    return true;
                                } else {
                                    L.Common.showErrorTip("提示", result.msg || "保存排序发生错误");
                                    return false;
                                }
                            },
                            error: function () {
                                L.Common.showErrorTip("提示", "保存排序请求发生异常");
                                return false;
                            }
                        });
                    }
                });
                d.show();
            });
        },

        initSelectorClickEvent: function (type, context) {
            var op_type = type;
            $(document).on("click", ".selector-item", function () {
                var self = $(this);
                var selector_id = self.attr("data-id");
                var selector_name = self.attr("data-name");
                if (selector_name) {
                    $("#rules-section-header").text(global_settings.g_name + "【" + selector_name + "】" + global_settings.c_name + "列表");
                }

                $(".selector-item").each(function () {
                    $(this).removeClass("selected-selector");
                })
                self.addClass("selected-selector");

                $("#add-btn").attr("data-id", selector_id);
                _this.loadRules(op_type, context, selector_id);
            });
        },

        resetSwitchBtn: function (enable, type) {
            var op_type = type;

            var self = $("#switch-btn");
            var parent = self.parent()
            var switch_name = global_settings.t_name

            if (global_settings.t_name && global_settings.t_name.length > 0) {
                if (enable == true) { //当前是开启状态，则应显示“关闭”按钮
                    self.attr("data-on", "yes");
                    self.removeClass("btn-info").addClass("btn-danger");
                    self.find("i").removeClass("fa-play").addClass("fa-pause");
                    self.find("span").text("停用该" + switch_name);
                } else {
                    self.attr("data-on", "no");
                    self.removeClass("btn-danger").addClass("btn-info");
                    self.find("i").removeClass("fa-pause").addClass("fa-play");
                    self.find("span").text("启用该" + switch_name);
                }
            } else {
                self.remove();
            }
        },

        loadConfigs: function (type, context, page_load, callback) {
            var op_type = type;

            if (global_settings.c_name == "插件") {
                $("#add-btn").empty()
                $("#add-btn").attr("style", "display: none")
            } else {
                $("#add-plugin-select").remove()
            }

            var api_name = global_settings.i_key + 's'
            $.ajax({
                url: '/' + op_type + '/' + api_name,
                type: 'get',
                cache: false,
                data: {},
                dataType: 'json',
                success: function (result) {
                    if (result.success) {
                        _this.resetSwitchBtn(result.data.enable, op_type);
                        $("#switch-btn").show();
                        $("#view-btn").show();

                        var enable = result.data.enable;
                        var meta = result.data.meta;
                        var selectors = result.data[api_name];

                        //重新设置数据
                        context.data.enable = enable;
                        context.data.meta = meta;
                        context.data.selectors = selectors;

                        _this.renderSelectors(meta, selectors);

                        if (page_load) { //第一次加载页面
                            var selector_lis = $("#selector-list li");
                            if (selector_lis && selector_lis.length > 0) {
                                $(selector_lis[0]).click();
                            }
                        }

                        callback && callback();
                    } else {
                        _this.showErrorTip("错误提示", "查询" + op_type + "配置请求发生错误");
                    }
                },
                error: function () {
                    _this.showErrorTip("提示", "查询" + op_type + "配置请求发生异常");
                }
            });
        },

        refreshConfigs: function (type, context) { //刷新本地缓存，fix  issue #110 (https://github.com/meyer-net/snake/issues/110)
            var op_type = type;
            $.ajax({
                url: '/' + op_type + '/' + global_settings.i_key + 's',
                type: 'get',
                cache: false,
                data: {},
                dataType: 'json',
                success: function (result) {
                    if (result.success) {
                        var enable = result.data.enable;
                        var meta = result.data.meta;
                        var selectors = result.data.selectors;

                        //重新设置数据
                        context.data.enable = enable;
                        context.data.meta = meta;
                        context.data.selectors = selectors;
                    } else {
                        _this.showErrorTip("错误提示", "刷新" + op_type + "配置的本地缓存发生错误， 请刷新页面！");
                    }
                },
                error: function () {
                    _this.showErrorTip("提示", "查询" + op_type + "配置的本地缓存发生异常， 请刷新页面！");
                }
            });
        },

        loadRules: function (type, context, selector_id) {
            var op_type = type;
            $.ajax({
                url: '/' + op_type + '/selectors/' + selector_id + "/rules",
                type: 'get',
                cache: false,
                data: {},
                dataType: 'json',
                success: function (result) {
                    if (result.success) {
                        $("#switch-btn").show();
                        $("#view-btn").show();

                        //重新设置数据
                        context.data.selector_rules = context.data.selector_rules || {};
                        context.data.selector_rules[selector_id] = result.data.rules;
                        _this.renderRules(result.data);
                    } else {
                        _this.showErrorTip("错误提示", "查询" + op_type + global_settings.c_name + "发生错误");
                    }
                },
                error: function () {
                    _this.showErrorTip("提示", "查询" + op_type + global_settings.c_name + "发生异常");
                }
            });
        },

        emptyRules: function () {
            $("#rules-section-header").text(global_settings.g_name + "-" + global_settings.c_name + "列表");
            $("#rules").html("");
            $("#add-btn").removeAttr("data-id");
        },

        renderSelectors: function (meta, selectors) {
            var tpl = L.Common.findTemplate("#selector-item-tpl").html();
            var to_render_selectors = [];
            if (meta && selectors) {
                var to_render_ids = meta[global_settings.i_key + "s"];
                if (to_render_ids) {
                    for (var i = 0; i < to_render_ids.length; i++) {
                        if (selectors[to_render_ids[i]]) {
                            to_render_selectors.push(selectors[to_render_ids[i]]);
                        }
                    }
                }
            }

            var html = juicer(tpl, {
                selectors: to_render_selectors
            });
            $("#selector-list").html(html);
        },

        renderToSelectBySelectors: function (select_selector, selectors) {
            Object.keys(selectors).forEach(key => {
                const data = selectors[key];
                $(select_selector).append("<option value='" + data.id + "'>" + data.name + "</option>");
            });
        },

        renderRules: function (data) {
            data = data || {};
            if (!data.rules || data.rules.length < 1) {
                var html = '<div class="alert alert-warning" style="margin: 25px 0 10px 0;">' +
                    '<p>该列表下没有' + global_settings.c_name + ',请添加!</p>' +
                    '</div>';
                $("#rules").html(html);
            } else {

                var html = _this.findTemplateHtmls("#rule-item-tpl", data.rules, function (rule) {
                    return {
                        "rules": [rule]
                    }
                });

                $("#rules").html(html);
            }
        },

        showErrorTip: function (title, content) {
            toastr.options = {
                "closeButton": true,
                "debug": false,
                "progressBar": true,
                "positionClass": "toast-top-right",
                "onclick": null,
                "showDuration": "400",
                "hideDuration": "10000",
                "timeOut": "7000",
                "extendedTimeOut": "10000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }
            toastr.error(content, title || "错误提示");
        },

        showTipDialog: function (title, content) {
            toastr.options = {
                "closeButton": true,
                "debug": false,
                "progressBar": true,
                "positionClass": "toast-top-right",
                "onclick": null,
                "showDuration": "400",
                "hideDuration": "3000",
                "timeOut": "7000",
                "extendedTimeOut": "3000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }
            toastr.success(content, title || "提示");
        },

        resetNav: function (select) {
            $("#side-menu li").each(function () {
                $(this).removeClass("active")
            });

            if (select) {
                $("#side-menu li#" + select).addClass("active");
            }
        },

        formatDate: function (now) {
            now = now || new Date();
            var year = now.getFullYear();
            var month = now.getMonth() + 1;
            var date = now.getDate();
            var hour = now.getHours();
            var minute = now.getMinutes();
            var second = now.getSeconds();
            if (minute < 10) minute = "0" + minute;
            if (hour < 10) hour = "0" + hour;
            if (second < 10) second = "0" + second;
            return year + "-" + month + "-" + date + " " + hour + ":" + minute + ":" + second;
        },

        formatTime: function (now) {
            now = now || new Date();
            var hour = now.getHours();
            var minute = now.getMinutes();
            var second = now.getSeconds();
            if (minute < 10) minute = "0" + minute;
            if (hour < 10) hour = "0" + hour;
            if (second < 10) second = "0" + second;
            return hour + ":" + minute + ":" + second;
        }
    };
}(APP));