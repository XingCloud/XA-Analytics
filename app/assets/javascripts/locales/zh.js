var I18n = I18n || {};
I18n.translations = {
    "zh": {
        "views": {
            "dimensions": {
                "form_list": {
                    "alert": "最多支持6个报告维度"
                }
            },
            "metrics": {
                "form_list": {
                    "alert": "不能重复添加相同指标"
                }
            }
        },
        "templates": {
            "action_logs":{
                "index":{
                    "name_column": "名称",
                    "resource_type_column": "资源类型",
                    "resource_name_column": "资源名称",
                    "triggered_by_column": "操作者",
                    "triggered_time_column": "操作时间"
                }
            },
            "charts": {
                "dimensions": {
                    "no_dimension": "暂无细分, 请添加(最多支持6层细分)",
                    "choose_segment": "选择用户群",
                    "total_dimensions": "总共 {{count}} 项细分" ,
                    "no_category": "未细分",
                    "dimension_date": "展示数据日期"
                },
                "kpis": {
                    "latest_days": "近{{days}}天",
                    "metric_name": "指标名称",
                    "data_summary": "数据汇总",
                    "user_percentage": "占总用户%"
                }
            },
            "dimensions":{
                "form_list": {
                    "dimensions": "报告维度",
                    "add_dimension": "添加维度"
                },
                "list": {
                    "shard_rule": "分段规则",
                    "change_shard_rule": "修改分段规则",
                    "shard_rule_helper": "用数字表示，数字与数字之间用逗号隔开"
                },
                "tags": {
                    "all": "所有"
                }
            },
            "expressions": {
                "form": {
                    "handler_placeholder": "日期偏移"
                }
            },
            "maintenance_plans": {
                "form": {
                    "edit": "编辑维护计划",
                    "new": "新建维护计划",
                    "start": "开始时间",
                    "end": "结束时间",
                    "announcement": "公告内容",
                    "keep_running": "保持服务运转"
                },
                "index": {
                    "header": "维护计划管理",
                    "add": "新增维护计划",
                    "start": "开始",
                    "end": "结束",
                    "created_by": "创建人",
                    "keep_running": "保持服务运转",
                    "announcement": "内容",
                    "no_data": "暂无维护计划"
                }
            },
            "metrics": {
                "form_list": {
                    "group": "指标组",
                    "add": "添加指标"
                },
                "form": {
                    "edit": "编辑指标",
                    "new": "新建指标",
                    "name": "指标名称",
                    "default_name": "新建指标",
                    "description": "指标描述",
                    "event_name": "事件名称",
                    "event_calculate_method": "事件计算方法",
                    "offset": "报告偏移",
                    "from": "从距当前",
                    "to": "天到距当前",
                    "segment": "用户群",
                    "scale": "伸缩系数",
                    "combine": "与另一事件组合计算",
		    "value_type" : "显示格式",
		    "origin_value_type": "原始值",
		    "percent_value_type" : "百分比"		    
                },
                "index_dropdown": {
                    "add_metric": "新建指标"
                }
            },
            "projects": {
                "init": {
                    "initializing": "初始化...0%",
                    "load_error": "资源载入出错"
                },
                "no_report": {
                    "guide": "强大的自定义报告功能可以让你获得最为精准的游戏数据，快去创建第一份报告吧",
                    "add": "创建报告"
                },
                "settings": {
                    "header": "项目设置",
                    "user_attributes": "自定义属性",
                    "custom_event_names": "自定义事件字段名",
		            "privilege_admin" : "权限管理",
                    "segments_management": "用户群管理"
                },
                "show": {
                    "degrade": "回旧版",
                    "action_logs": "操作日志",
                    "change_language": "修改语言"
                }
            },
            "report_categories": {
                "form": {
                    "edit": "编辑分类",
                    "new": "新建分类",
                    "name": "分类名称",
                    "default_name": "新建分类"
                }
            },
            "report_tabs": {
                "form_body": {
                    "title": "标签标题",
                    "default_title": "新建标签",
                    "type": "类型",
                    "line_chart": "线状图",
                    "bar_chart": "柱状图",
		    "area_chart" : "积分图",
                    "advanced_options": "高级选项",
                    "length": "报告时长",
                    "offset": "默认截止到距今",
                    "frequency": "报告频率",
                    "compare": "与过去对比",
                    "show_table": "显示数据表格"
                },
                "form_header": {
                    "default_title": "新建标签"
                },
                "show_custom_range": {
                    "header": "您想看：",
                    "end_at": "截止到",
                    "length": "时长为",
                    "every": "每",
                    "every_post": "一个点",
                    "error": {
                        "err_future": "不能看未来的数据。",
                        "err_days": "请少观察一段时间。",
                        "err_points": "图上的点太多了。",
                        "err_today": "今天还没结束呢。试试今天的每小时或5分钟"
                    }
                },
                "show_range_picker": {
                    "to": "截止到",
                    "custom": "自定义{{length}}天",
                    "interval": "每{{interval}}数据",
                    "compare": "对比截止到"
                }
            },
            "reports": {
                "form": {
                    "edit": "编辑报告",
                    "new": "新建报告",
                    "default_title": "新建报告",
                    "add_report_tab": "新建标签"
                },
                "left_nav": {
                    "add_report": "添加报告",
                    "dashboard": "数据面板",
                    "settings": "项目设置"
                },
                "show": {
                    "timezone": "报告时区为UTC+0"
                },
                "list": {
                    "header": "通用报告",
                    "add_report": "添加报告",
                    "add_category": "添加分类"
                }
            },
            "segments": {
                "form": {
                    "edit": "编辑用户群",
                    "new": "新建用户群",
                    "default_name": "新建用户群",
                    "filter": "过滤条件",
                    "add_and": '添加"AND"语句'
                },
                "index": {
                    "header": "用户群管理",
                    "add": "添加用户群"
                },
                "list": {
                    "choose": "选择用户群",
                    "default": "默认用户群",
                    "custom": "自定义用户群",
                    "add": "新建用户群"
                },
                "tags": {
                    "manage": "管理用户群"
                }
            },
            "settings": {
                "event_level_form": {
                    "level": "事件第{{level}}层"
                }
            },
            "user_attributes": {
                "form": {
                    "edit": "编辑属性",
                    "new": "新建属性",
                    "default_name": "新建属性",
                    "identifier": "字段",
                    "identifier_helper": "字段必须为数字、字母和下划线组合",
                    "type": "类型",
                    "shard_rule": "分段规则",
                    "shard_rule_helper": "用数字表示，数字与数字之间用逗号隔开"
                },
                "index": {
                    "add": "添加属性",
                    "shard_rule": "分段规则"
                }
            },
	    "project_users":{
		"user" : "项目成员",
		"role" : "角色",
		"access_reports" : "允许查看报告",
		"normal_role" : "普通用户",
		"mgriant_role" : "外来用户",
		"unlimited" : "无限制",
		"current_user" : "(当前用户)",
		"form":{
		    "edit" : "编辑用户"
		}

	    },
            "utils": {
                "404": {
                    "message": "您访问的资源不存在或者已删除，请访问其他资源",
                    "back": "回首页"
                },
                "error": {
                    "400": "资源操作失败，请检查参数是否正确",
                    "404": "您访问的资源不存在或已删除，请",
                    "401": "您会话已过期，请",
                    "403": "操作被禁止",
                    "503": "服务器维护中，服务暂不可用请稍后再试",
                    "refresh": "刷新页面",
                    "relogin": "重新登陆"
                },
                "success": {
                    "message": "操作成功"
                }
            },
            "widgets": {
                "form_metric": {
                    "choose_metric": "选择指标"
                },
                "form":{
                    "edit": "编辑小窗口",
                    "new": "新建小窗口",
                    "timeline": "时间线",
                    "dimension_item": "细分项",
                    "frequency": "频率",
                    "length": "时长(天)",
                    "report_tab": "指向报告标签"
                },
                "list": {
                    "add": "添加小窗口"
                }
            },
            "translations": {
                "index": {
                    "header": "翻译管理",
                    "choose_resource": "资源",
                    "choose_field": "字段",
                    "choose_language": "语言",
                    "is_finished": "是否完成",
                    "resource_id": "资源ID",
                    "original_text": "原文本",
                    "translated_text": "翻译后文本",
                    "unfinished": "显示未完成"
                },
                "form": {
                    "edit": "编辑翻译",
                    "new": "新增翻译",
                    "original_text": "原文",
                    "translated_text": "翻译"
                },
                "list": {
                    "header": "报告管理",
                    "add_report": "添加报告",
                    "add_category": "添加分类"
                }
            },
            "user_preferences": {
                "set_language": {
                    "title": "设置语言"
                }
            }
        },
        "commons": {
            "days": "天",
            "items": "项",
            "pages": "页",
            "next_page": "下一页",
            "previous_page": "上一页",
            "jump_to": "跳到第",
            "pending": "更新中...",
            "no_data": "没有数据" ,
            "show": "显示",
            "modify": "修改",
            "search": "搜索",
            "submit": "提交",
            "ok": "确定",
            "save": "保存",
            "cancel": "取消",
            "and": "和",
            "yes": "是",
            "no": "否",
            "required": "必填",
            "second": "秒",
            "minute": "分钟",
            "hour": "小时",
            "day": "天",
            "month": "月",
            "week": "周",
            "year": "年",
            "title": "标题",
            "name": "名称",
            "identifier": "标识符(服)",
            "description": "描述",
            "announcement": "公告",
            "custom": "自定义",
            "all": "所有",
            "type": "类型",
            "edit": "编辑",
            "add": "新增",
            "copy": "复制",
            "modify": "修改",
            "delete": "删除",
            "uncategorized": "未分类",
            "up": "向上",
            "down": "向下",
            "action": "操作",
            "created_at": "创建时间",
            "updated_at": "更新时间",
            "refresh": "刷新",
            "to": "截止到",
            "confirm_delete": "确认删除？",
            "loaded": "已载入",
            "language": "语言"
        },
        "resources": {
            "dimension": "细分",
            "report_category": "报告分类",
            "report": "报告",
            "report_tab": "报告标签",
            "metric": "指标",
            "segment": "用户群",
            "widget": "小窗口",
            "maintenance_plan": "维护计划",
            "project": "项目",
            "setting": "设置",
            "user_attribute": "用户属性" ,
            "action_log": "操作日志",
            "translation": "语言文件",
            "user_preference": "用户设置"
        },
        "statics": {
            "user_attributes": {
                "register_time": "注册时间",
                "last_login_time": "最后登陆时间",
                "first_pay_time": "首次付费时间",
                "last_pay_time": "最后付费时间",
                "grade": "等级",
                "game_time": "游戏时间",
                "pay_amount": "付费量",
                "language": "语言",
                "nation": "国家",
                "platform": "平台",
                "identifier": "标识符(服)",
                "ref": "来源",
                "version": "版本",
                "ref0": "来源第一层",
                "ref1": "来源第二层",
                "ref2": "来源第三层",
                "ref3": "来源第四层",
                "ref4": "来源第五层"
            },
            "expression_operators": {
                "gt": "大于",
                "gte": "大于等于",
                "lt": "小于",
                "lte": "小于等于",
                "eq": "等于",
                "handler": "相对时间"
            },
            "metric_combine_actions": {
                "addition": "加法",
                "division": "除法(算百分比)",
                "multiplication": "乘法",
                "subduction": "减法"
            },
            "metric_conditions": {
                "count": "发生的次数",
                "sum": "值的总和",
                "user_num": "发生的用户人数"
            },
            "events": {
                "event0": "事件第一层",
                "event1": "事件第二层",
                "event2": "事件第三层",
                "event3": "事件第四层",
                "event4": "事件第五层",
                "event5": "事件第六层"

            },
            "report_tab_ranges": {
                "realtime": "实时",
                "current_day": "当天",
                "2_days": "最近两天",
                "this_week": "最近一周",
                "2_weeks": "最近两周",
                "this_month": "最近一月",
                "2_months": "最近两月"
            },
            "user_attribute_types":{
                "sql_string": "字符串",
                "sql_bigint": "数值",
                "sql_datetime": "日期"
            }
        },
        "errors": {
            "err_default": "服务器开小差了，请稍候再试",
            "err_11": "请求参数为空，请联系管理员",
            "err_12751": "NumberOfDay和Interval非法。如果指标的定义涉及多天的数据的计算，那么您不能以小于一天（小时或分钟）为间隔来展示这个指标。",
            "err_1275": "参数非法，请联系管理员",
            "err_12": "Json解析错误，请联系管理员",
            "err_20": "开始/结束日期非法，请联系管理员",
            "err_22": "Segment解析和处理过程中发生异常，请联系管理员",
            "err_37": "查询异常，请联系管理员",
            "err_39": "汇总Total和Natural过程中发生异常，请联系管理员",
            "err_36": "没有此项目的数据。请联系打日志的技术人员或者管理员",
            "err_timeout": "服务器查询超时，请稍候再试",
            "err_unknown": "未知错误，请稍候再试"
        },
        "lib": {
            utils:{
                "not_empty": "不能为空",
                "should_be_integer": "必须为整数",
                "should_be_number": "必须为数字",
                "should_be_natural_number": "必须为大于或等于0的整数"
            }
        }
    }
};
