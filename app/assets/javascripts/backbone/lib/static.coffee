Analytics.Static ||= {}

Analytics.Static.user_attributes = () ->
  [
    {name: 'register_time', nickname: I18n.t("statics.user_attributes.register_time"), atype: 'sql_datetime'},
    {name: 'last_login_time', nickname: I18n.t("statics.user_attributes.last_login_time"), atype: 'sql_datetime'},
    {name: 'first_pay_time', nickname: I18n.t("statics.user_attributes.first_pay_time"), atype: 'sql_datetime'},
    {name: 'last_pay_time', nickname: I18n.t("statics.user_attributes.last_pay_time"), atype: 'sql_datetime'},
    {name: 'grade', nickname: I18n.t("statics.user_attributes.grade"), atype: 'sql_bigint', gpattern: '0,5,10,20,50,100'},
    {name: 'game_time', nickname: I18n.t("statics.user_attributes.game_time"), atype: 'sql_bigint', gpattern: '0,5,10,20,50,100'},
    {name: 'pay_amount', nickname: I18n.t("statics.user_attributes.pay_amount"), atype: 'sql_bigint', gpattern: '0,5,10,20,50,100'},
    {name: 'language', nickname: I18n.t("statics.user_attributes.language"), atype: 'sql_string'},
    {name: 'nation', nickname: I18n.t("statics.user_attributes.nation"), atype: 'sql_string'},
    {name: 'platform', nickname: I18n.t("statics.user_attributes.platform"), atype: 'sql_string'},
    {name: 'identifier', nickname: I18n.t("statics.user_attributes.identifier"), atype: 'sql_string'},
    {name: 'ref', nickname: I18n.t("statics.user_attributes.ref"), atype: 'sql_string'},
    {name: 'ref0', nickname: I18n.t("statics.user_attributes.ref0"), atype: 'sql_string'},
    {name: 'ref1', nickname: I18n.t("statics.user_attributes.ref1"), atype: 'sql_string'},
    {name: 'ref2', nickname: I18n.t("statics.user_attributes.ref2"), atype: 'sql_string'},
    {name: 'ref3', nickname: I18n.t("statics.user_attributes.ref3"), atype: 'sql_string'},
    {name: 'ref4', nickname: I18n.t("statics.user_attributes.ref4"), atype: 'sql_string'},
    {name: 'version', nickname: I18n.t("statics.user_attributes.version"), atype: 'sql_string'}
  ]

Analytics.Static.expression_operators = () ->
  [
    {value: 'gt', name: I18n.t("statics.expression_operators.gt")},
    {value: 'gte', name: I18n.t("statics.expression_operators.gte")},
    {value: 'lt', name: I18n.t("statics.expression_operators.lt")},
    {value: 'lte', name: I18n.t("statics.expression_operators.lte")},
    {value: 'eq', name: I18n.t("statics.expression_operators.eq")},
    {value: 'handler', name: I18n.t("statics.expression_operators.handler")}
  ]

Analytics.Static.metric_combine_actions = () ->
  [
    {value: 'addition', name: I18n.t("statics.metric_combine_actions.addition")},
    {value: 'division', name: I18n.t("statics.metric_combine_actions.division")},
    {value: 'multiplication', name: I18n.t("statics.metric_combine_actions.multiplication")},
    {value: 'subduction', name: I18n.t("statics.metric_combine_actions.subduction")}
  ]

Analytics.Static.metric_conditions = () ->
  [
    {value: 'count', name: I18n.t("statics.metric_conditions.count")},
    {value: 'sum', name: I18n.t("statics.metric_conditions.sum")},
    {value: 'user_num', name: I18n.t("statics.metric_conditions.user_num")}
  ]

Analytics.Static.dimensions_events = () ->
  [
    {value: "0", name: I18n.t("statics.events.event0"), dimension_type: 'EVENT', value_type: 'sql_string'},
    {value: "1", name: I18n.t("statics.events.event1"), dimension_type: 'EVENT', value_type: 'sql_string'},
    {value: "2", name: I18n.t("statics.events.event2"), dimension_type: 'EVENT', value_type: 'sql_string'},
    {value: "3", name: I18n.t("statics.events.event3"), dimension_type: 'EVENT', value_type: 'sql_string'},
    {value: "4", name: I18n.t("statics.events.event4"), dimension_type: 'EVENT', value_type: 'sql_string'},
    {value: "5", name: I18n.t("statics.events.event5"), dimension_type: 'EVENT', value_type: 'sql_string'}
  ]

Analytics.Static.report_tab_intervals = () ->
  [
    {name: "5" + I18n.t("commons.minute"), value: "min5"},
    {name: I18n.t("commons.hour"), value: "hour"},
    {name: I18n.t("commons.day"), value: "day"},
    {name: I18n.t("commons.week"), value: "week"},
    {name: I18n.t("commons.month"), value: "month"}
  ]

Analytics.Static.user_attribute_types = () ->
  [
    {key: "sql_string", value: I18n.t("statics.user_attribute_types.sql_string")},
    {key: "sql_bigint", value: I18n.t("statics.user_attribute_types.sql_bigint")},
    {key: "sql_datetime", value: I18n.t("statics.user_attribute_types.sql_datetime")}
  ]

Analytics.Static.report_tab_ranges = () ->
  [
    {name: I18n.t("statics.report_tab_ranges.realtime"), length: 1, interval: "min5"},
    {name: I18n.t("statics.report_tab_ranges.current_day"), length: 1, interval: "hour"},
    {name: I18n.t("statics.report_tab_ranges.2_days"), length: 2, interval: "hour"},
    {name: I18n.t("statics.report_tab_ranges.this_week"), length: 7, interval: "day"},
    {name: I18n.t("statics.report_tab_ranges.2_weeks"), length: 14, interval: "day"},
    {name: I18n.t("statics.report_tab_ranges.this_month"), length: 28, interval: "day"},
    {name: I18n.t("statics.report_tab_ranges.2_months"), length: 56, interval: "week"}
  ]

Analytics.Static.action_names =  () ->
  {
    "create": {name: I18n.t("commons.add"), color: "green"}
    "update": {name: I18n.t("commons.modify"), color: "blue"}
    "destroy": {name: I18n.t("commons.delete"), color: "red"}
  }

Analytics.Static.resource_types = () ->
  {
    "Report": I18n.t("resources.report")
    "Metric": I18n.t("resources.metric")
    "Project": I18n.t("resources.project")
    "ReportCategory": I18n.t("resources.report_category")
    "ReportTab": I18n.t("resources.report_tab")
    "Segment": I18n.t("resources.segment")
    "Setting": I18n.t("resources.setting")
    "UserAttribute": I18n.t("resources.user_attribtue")
    "Widget": I18n.t("resources.widget")
  }

Analytics.Static.getDimensionsEvents = () ->
  events = Analytics.Static.dimensions_events()
  if Instances.Models.setting?
    for event in events
      event_level = Instances.Models.setting.get("event_level")
      if event_level? and event_level.split(".")[parseInt(event.value)]? and event_level.split(".")[parseInt(event.value)] != ""
        event.name = event_level.split(".")[parseInt(event.value)]
  events

Analytics.Static.getUserAttributes = () ->
  results = []
  for user_attribute in _.sortBy(Instances.Collections.user_attributes.models, (item) -> 0 - Date.parse(item.get("created_at")))
    attrs = _.clone(user_attribute.attributes)
    if not attrs.nickname?
      item = _.find(Analytics.Static.user_attributes(), (item) -> item.name == attrs.name)
      if item?
        attrs.nickname = item.nickname
    results.push(attrs)
  for user_attribute in Analytics.Static.user_attributes()
    item = Instances.Collections.user_attributes.find((item) -> item.get("name") == user_attribute.name)
    if not item?
      results.push(user_attribute)
  results

Analytics.Static.getDimensions = () ->
  user_attributes = Analytics.Static.getUserAttributes()
  results = []
  for user_attribute in user_attributes
    results.push({value: user_attribute.name, name: user_attribute.nickname, dimension_type: 'USER_PROPERTIES', value_type: user_attribute.atype})
  results.concat(Analytics.Static.getDimensionsEvents())

Analytics.Static.getDimensionName = (key) ->
  dimension = _.find(Analytics.Static.getDimensions(), (dimension) -> dimension.value == key)
  if dimension?
    dimension.name
  else
    key