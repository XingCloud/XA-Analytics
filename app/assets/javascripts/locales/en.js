var I18n = I18n || {};
I18n.translations = {
    "en":{
        "views":{
            "dimensions":{
                "form_list":{
                    "alert":"Support max 6 dimensions"
                }
            },
            "metrics":{
                "form_list":{
                    "alert":"Can not add a metric twice"
                }
            }
        },
        "templates":{
            "action_logs":{
                "index":{
                    "name_column":"Name",
                    "resource_type_column":"Resource Type",
                    "resource_name_column":"Resource Name",
                    "triggered_by_column":"Triggered By",
                    "triggered_time_column":"Triggered Time"
                }
            },
            "charts":{
                "dimensions":{
                    "no_dimension":"No dimension. Please add (Support most 6 dimensions)",
                    "choose_segment":"Choose Segment",
                    "total_dimensions":"Total {{count}} Segment(s)",
                    "no_category":"No category",
                    "dimension_date":"Data Date"
                },
                "kpis":{
                    "latest_days":"Latest {{days}} day(s)",
                    "metric_name":"Metric Name",
                    "data_summary":"Data Summary",
                    "user_percentage":"User Percentage"
                }
            },
            "dimensions":{
                "form_list":{
                    "dimensions":"Dimensions",
                    "add_dimension":"Add Dimension"
                },
                "list":{
                    "shard_rule":"shard rule",
                    "change_shard_rule":"modify shard rule",
                    "shard_rule_helper":"use number separated by comma"
                },
                "tags":{
                    "all":"ALL",
                    "manage":"Manage User Attributes"
                }
            },
            "expressions":{
                "form":{
                    "handler_placeholder":"Date offset",
                    "in_placeholder": "Identifiers separated by comma",
                    "date_in_placeholder": "Date(YYYY-MM-DD) separated by comma"
                }
            },
            "maintenance_plans":{
                "form":{
                    "edit":"Edit",
                    "new":"New",
                    "start":"Start",
                    "end":"End",
                    "announcement":"Announcement",
                    "keep_running":"Keep Running",
                    "active":"Active",
                    "nonactive":"Expired"
                },
                "index":{
                    "header":"Maintenance Plans Management",
                    "add":"Add Maintenance Plan",
                    "start":"Start",
                    "end":"End",
                    "created_by":"Created By",
                    "keep_running":"Keep Running",
                    "announcement":"Announcement",
                    "no_data":"No Maintenance Plan",
                    "total_time": "Amount of current month's maintenance time: {{hours}} Hours，{{minutes}} Minutes"
                }
            },
            "metrics":{
                "form_list":{
                    "group":"Metrics",
                    "add":"Add Metric"
                },
                "form":{
                    "edit":"Edit",
                    "new":"New",
                    "name":"Name",
                    "default_name":"new metric",
                    "description":"Description",
                    "event_name":"Event",
                    "event_calculate_method":"Calculate method",
                    "offset":"Offset",
                    "from":"From last",
                    "to":"day(s) to last",
                    "segment":"Segment",
                    "scale":"Scale",
                    "filter_between_placeholder": "input two value, separated by comma",
                    "filter": "Filter",
                    "combine":"Combine with another",
                    "value_type":"Display",
                    "origin_value_type":"origin",
                    "percent_value_type":"percent",
		            "rounding_value_type":"rounding",
                    "since":"since",
                    "start":""
                },
                "index_dropdown":{
                    "add_metric":"Add Metric"
                }
            },
            "projects":{
                "init":{
                    "initializing":"Initializing...0%",
                    "load_error":"Load error"
                },
                "no_report":{
                    "guide":"By our fascinating features, You can create your own reports for satisfying your special needs",
                    "add":"Add Report"
                },
                "settings":{
                    "header":"Settings",
                    "user_attributes":"User attributes",
                    "custom_event_names":"Event names",
                    "privilege_admin":"Privilege administrator",
                    "segments_management":"Segments Management"
                },
                "show":{
                    "degrade":"Old version",
                    "action_logs":"Action logs",
                    "change_language":"Change Language"
                },
                "index": {
                    "loading": "Loading Projects",
                    "load_more": "Load More",
                    "no_more": "No More Projects",
                    "users": "Users",
                    "reports": "Reports",
                    "metrics": "Metrics",
                    "segments": "Segments",
                    "name": "Name",
                    "income": "Income",
                    "active_user": "Active User",
                    "new_user": "New User"
                },
                "header": {
                    "select_project": "Please select project..."
                }
            },
            "report_categories":{
                "form":{
                    "edit":"Edit",
                    "new":"New",
                    "name":"Name",
                    "default_name":"New Category"
                }
            },
            "report_tabs":{
                "form_body":{
                    "title":"Title",
                    "default_title":"new tab",
                    "type":"Chart type",
                    "line_chart":"Line",
                    "bar_chart":"Column",
                    "area_chart":"Integral",
                    "advanced_options":"Advanced options",
                    "length":"Length",
                    "offset":"Before",
                    "frequency":"Frequency",
                    "compare":"Compare to past",
                    "show_table":"Show data table"
                },
                "form_header":{
                    "default_title":"new tab"
                },
                "show_custom_range":{
                    "header":"Custom report time range",
                    "end_at":"End at",
                    "length":"Length",
                    "every":"Every",
                    "every_post":"a point",
                    "error":{
                        "err_future":"Cannot look into future.",
                        "err_days":"Too many days selected.",
                        "err_points":"Too many points in timeline.",
                        "err_today":"Today is not over yet. Try hourly/5min plot with today."
                    }
                },
                "show_range_picker":{
                    "to":"To",
                    "custom":"Custom {{length}} day(s)",
                    "interval":"Every {{interval}} data",
                    "compare":"Compare to"
                }
            },
            "reports":{
                "form":{
                    "edit":"Edit Report",
                    "new":"New Report",
                    "default_title":"new report",
                    "add_report_tab":"Add Tab"
                },
                "left_nav":{
                    "add_report":"Add Report",
                    "dashboard":"Dashboard",
                    "settings":"Settings"
                },
                "list":{
                    "header":"Reports",
                    "add_report":"Add Report",
                    "add_category":"Add Category"
                },
                "show":{
                    "timezone":"Timezone is UTC+0"
                }
            },
            "segments":{
                "form":{
                    "edit":"Edit Segment",
                    "new":"New Segment",
                    "default_name":"new segment",
                    "filter":"Filters",
                    "add_and":'Add "AND" expression'
                },
                "index":{
                    "header":"Segments",
                    "add":"Add Segment"
                },
                "list":{
                    "choose":"Choose Segment",
                    "default":"Default Segments",
                    "custom":"Custom Segments",
                    "add":"Add Segment"
                },
                "tags":{
                    "manage":"Manage Segments"
                }
            },
            "settings":{
                "event_level_form":{
                    "level":"Event #{{level}} Level"
                }
            },
            "user_attributes":{
                "form":{
                    "edit":"Edit Attribute",
                    "new":"New Attribute",
                    "default_name":"new attribute",
                    "identifier":"Identifier",
                    "identifier_helper":"Muse be letters, numbers or underline",
                    "type":"Type",
                    "shard_rule":"Shard rule",
                    "shard_rule_int_helper":"use number separated by comma",
                    "shard_rule_date_helper":"use date(YYYY-MM-DD) separated by comma"
                },
                "index":{
                    "add":"Add Attribute",
                    "shard_rule":"Shard Rule"
                }
            },
            "project_users":{
                "user":"members",
                "role":"role",
                "access_reports":"access reports",
                "normal_role":"normal",
                "mgriant_role":"mgriant",
                "unlimited":"unlimited",
                "current_user":"(current user)",
                "form":{
                    "edit":"Edit user"
                }
            },
            "utils":{
                "404":{
                    "message":"The resource you access is not exist now, please check other resources",
                    "back":"Back to home"
                },
                "error":{
                    "400":"Failed to operate resource, please check your parameters",
                    "404":"The resource you access is not exist now, please",
                    "401":"Your session have expired, please",
                    "403":"The operation was fobidden",
                    "503":"Server under maintenance now, please try it later",
                    "refresh":"refresh the page",
                    "relogin":"relogin"
                },
                "success":{
                    "message":"Success"
                }
            },
            "widgets":{
                "form_metric":{
                    "choose_metric":"Choose metric"
                },
                "form":{
                    "edit":"Edit Widget",
                    "new":"New Widget",
                    "timeline":"Timeline",
                    "dimension_item":"Dimension item",
                    "frequency":"Frequency",
                    "length":"long(day)",
                    "report_tab":"Link to"
                },
                "list":{
                    "add":"Add widget"
                }
            },
            "translations":{
                "index":{
                    "header":"Translations",
                    "choose_resource":"Resource",
                    "choose_field":"Field",
                    "choose_language":"Language",
                    "is_finished":"Finished?",
                    "resource_id":"Resource ID",
                    "original_text":"Original Text",
                    "translated_text":"Translated Text",
                    "unfinished":"Show Unfinished"
                },
                "form":{
                    "edit":"Edit translation",
                    "new":"New translation",
                    "original_text":"Original",
                    "translated_text":"Translation"
                }
            },
            "user_preferences":{
                "set_language":{
                    "title":"Choose Language"
                }
            }
        },
        "commons":{
            "days":"day(s)",
            "items":"Item(s)",
            "pages":"Page(s)",
            "next_page":"Next Page",
            "previous_page":"Previous Page",
            "jump_to":"Jump to",
            "pending":"Pending...",
            "no_data":"No Data",
            "show":"Show",
            "modify":"Modify",
            "search":"Search",
            "submit":"Submit",
            "ok":"OK",
            "save":"Save",
            "cancel":"Cancel",
            "and":"And",
            "yes":"Yes",
            "no":"No",
            "required":"Required",
            "second":"Second",
            "minute":"Minute",
            "hour":"Hour",
            "day":"Day",
            "month":"Month",
            "week":"Week",
            "year":"Year",
            "title":"Title",
            "name":"Name",
            "identifier":"Identifier",
            "description":"Description",
            "announcement":"Announcement",
            "custom":"Custom",
            "all":"All",
            "type":"Type",
            "edit":"Edit",
            "add":"Add",
            "copy":"Copy",
            "delete":"Delete",
            "modify":"Modify",
            "uncategorized":"Uncategorized",
            "up":"Shift Up",
            "down":"Shift Down",
            "action":"Action",
            "created_at":"Created at",
            "updated_at":"Updated at",
            "refresh":"Refresh",
            "to":"To",
            "confirm_delete":"Are sure to delete this?",
            "loaded":"Loaded ",
            "language":"language",
            "none": "None"
        },
        "resources":{
            "dimension":"Dimension",
            "report_category":"Report Category",
            "report":"Report",
            "report_tab":"Report Tab",
            "metric":"Metric",
            "segment":"Segment",
            "widget":"Widget",
            "maintenance_plan":"Maintenance Plan",
            "project":"Project",
            "setting":"Setting",
            "user_attribute":"User Attribute",
            "action_log":"Action Log",
            "translation":"Language resources",
            "user_preference":"User Preference",
            "project_users":"Project Users"
        },
        "statics":{
            "user_attributes":{
                "register_time":"Registration time ",
                "last_login_time":"Last login time",
                "first_pay_time":"First payment time",
                "last_pay_time":"Last payment time",
                "grade":"Grade",
                "pay_amount":"Payment amount",
                "language":"Language",
                "nation":"Nation",
                "platform":"Platform",
                "identifier":"Identifier",
                "ref":"Reference",
                "version":"Version",
                "ref0":"Reference 1st level",
                "ref1":"Reference 2nd level",
                "ref2":"Reference 3rd level",
                "ref3":"Reference 4th level",
                "ref4":"Reference 5th level",
                "version": "Version",
                "geoip": "GeoIP"
            },
            "expression_operators":{
                "gt":"greater than",
                "gte":"greater and equal to",
                "lt":"less than",
                "lte":"less and equal to",
                "eq":"equal to",
                "handler":"handler",
                "in":"contains"
            },
            "metric_combine_actions":{
                "addition":"Addition",
                "division":"Division",
                "multiplication":"Multiplication",
                "subduction":"Subduction"
            },
            "metric_conditions":{
                "count":"Count",
                "sum":"Sum",
                "user_num":"Users Count"
            },
            "metric_filter_operators":{
                "gt": "Greater",
                "lt": "Less",
                "ge": "Greater Equal",
                "le": "Less Equal",
                "eq": "Equal",
                "ne": "Not Equal",
                "between": "Between"
            },
            "events":{
                "event0":"Event 1st level",
                "event1":"Event 2nd level",
                "event2":"Event 3rd level",
                "event3":"Event 4th level",
                "event4":"Event 5th level",
                "event5":"Event 6th level"

            },
            "report_tab_ranges":{
                "realtime":"Realtime",
                "current_day":"Today",
                "2_days":"Two Days",
                "this_week":"Last 7 Days",
                "2_weeks":"Last 14 Days",
                "this_month":"Last 30 Days",
                "2_months":"Two Months"
            },
            "user_attribute_types":{
                "sql_string":"String",
                "sql_bigint":"Number",
                "sql_datetime":"Date"
            }
        },
        "errors":{
            "err_default":"Oops, we got a problem here!",
            "err_11":"Null parameter，please contact the administrator",
            "err_12751":"Invalid 'NumberOfDay' and 'Interval'. If your report contains more than one day data, you can't set report interval less than a day",
            "err_1275":"Invalid parameter，please contact the administrator",
            "err_12":"Wrong json format，please contact the administrator",
            "err_20":"Invalid start or end date format，please contact the administrator",
            "err_22":"Failed to parse or operate segment，please contact the administrator",
            "err_35":"Error shard rule",
            "err_37":"Query exception，please contact the administrator",
            "err_39":"Failed to calculate 'Total' and 'Natural'，please contact the administrator",
            "err_36":"The statistics of your project is not exist，please contact the administrator",
            "err_40": "Unknown exception，please contact the administrator",
            "err_timeout":"Query timeout，please contact the administrator",
            "err_unknown":"Unknown exception，please contact the administrator"
        },
        "lib":{
            utils:{
                "not_empty":"cannot be empty",
                "should_be_integer":"must be integer",
                "should_be_number":"must be number",
                "should_be_natural_number":"must be natural number"
            }
        }
    }
};
