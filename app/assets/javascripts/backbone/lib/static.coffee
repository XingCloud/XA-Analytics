Analytics.Static ||= {}

Analytics.Static.UserAttributes = [
  {name: 'register_time', nickname: '注册时间', atype: 'sql_datetime'},
  {name: 'last_login_time', nickname: '最后登陆时间', atype: 'sql_datetime'},
  {name: 'first_pay_time', nickname: '首次付费时间', atype: 'sql_datetime'},
  {name: 'last_pay_time', nickname: '最后付费时间', atype: 'sql_datetime'},
  {name: 'grade', nickname: '等级', atype: 'sql_bigint', gpattern: '0,5,10,20,50,100'},
  {name: 'game_time', nickname: '游戏时间', atype: 'sql_bigint', gpattern: '0,5,10,20,50,100'},
  {name: 'pay_amount', nickname: '付费量', atype: 'sql_bigint', gpattern: '0,5,10,20,50,100'},
  {name: 'language', nickname: '语言', atype: 'sql_string'},
  {name: 'platform', nickname: '平台', atype: 'sql_string'},
  {name: 'identifier', nickname: '标识符', atype: 'sql_string'},
  {name: 'ref', nickname: '来源', atype: 'sql_string'},
  {name: 'ref0', nickname: '来源第一层', atype: 'sql_string'},
  {name: 'ref1', nickname: '来源第二层', atype: 'sql_string'},
  {name: 'ref2', nickname: '来源第三层', atype: 'sql_string'},
  {name: 'ref3', nickname: '来源第四层', atype: 'sql_string'},
  {name: 'ref4', nickname: '来源第五层', atype: 'sql_string'},
  {name: 'version', nickname: '版本', atype: 'sql_string'}
]

Analytics.Static.ExpressionOperator = [
  {value: 'gt', name: '大于'},
  {value: 'gte', name: '大于等于'},
  {value: 'lt', name: '小于'},
  {value: 'lte', name: '小于等于'},
  {value: 'eq', name: '等于'},
  {value: 'handler', name: '相对时间'}
]

Analytics.Static.MetricCombineAction = [
  {value: 'addition', name: '加法'},
  {value: 'division', name: '除法(算百分比)'},
  {value: 'multiplication', name: '乘法'},
  {value: 'subduction', name: '减法'}
]

Analytics.Static.MetricCondition = [
  {value: 'count', name: '发生的次数'},
  {value: 'sum', name: '值的总和'},
  {value: 'user_num', name: '发生的用户人数'}
]

Analytics.Static.MetricComparisonOperator = [
  {value: 'gt', name: '大于'},
  {value: 'ge', name: '大于等于'},
  {value: 'lt', name: '小于'},
  {value: 'le', name: '小于等于'},
  {value: 'eq', name: '等于'},
  {value: 'ne', name: '不等于'}
]

Analytics.Static.DimensionsEvents = [
  {value: "0", name: '事件字段第一层', dimension_type: 'EVENT', value_type: 'sql_string'},
  {value: "1", name: '事件字段第二层', dimension_type: 'EVENT', value_type: 'sql_string'},
  {value: "2", name: '事件字段第三层', dimension_type: 'EVENT', value_type: 'sql_string'},
  {value: "3", name: '事件字段第四层', dimension_type: 'EVENT', value_type: 'sql_string'},
  {value: "4", name: '事件字段第五层', dimension_type: 'EVENT', value_type: 'sql_string'},
  {value: "5", name: '事件字段第六层', dimension_type: 'EVENT', value_type: 'sql_string'}
]

Analytics.Static.ReportTabIntervals = [
  {name: "5分钟", value: "min5"},
  {name: "小时", value: "hour"},
  {name: "天", value: "day"},
  {name: "周", value: "week"},
  {name: "月", value: "month"}
]

Analytics.Static.UserAttributeTypes = [
  {key: "sql_string", value: "字符串"},
  {key: "sql_bigint", value: "数值"},
  {key: "sql_datetime", value: "日期"}
]

Analytics.Static.ReportTabRanges = [
  {name: "实时", length: 1, interval: "min5"},
  {name: "当天", length: 1, interval: "hour"},
  {name: "最近两天", length: 2, interval: "hour"},
  {name: "最近一周", length: 7, interval: "day"},
  {name: "最近二周", length: 14, interval: "day"},
  {name: "最近一个月", length: 28, interval: "day"},
  {name: "最近二个月", length: 56, interval: "week"}
]

Analytics.Static.ActionNames = {
  "create": {name: "新增", color: "green"}
  "update": {name: "修改", color: "blue"}
  "destroy": {name: "删除", color: "red"}
}

Analytics.Static.ResourceTypes = {
  "Report": "报告"
  "Metric": "指标"
  "Project": "项目"
  "ReportCategory": "报告分类"
  "ReportTab": "报告标签"
  "Segment": "用户群"
  "Setting": "设置"
  "UserAttribute": "用户属性"
  "Widget": "小窗口"
}

Analytics.Static.getDimensionsEvents = () ->
  events = Analytics.Static.DimensionsEvents
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
      item = _.find(Analytics.Static.UserAttributes, (item) -> item.name == attrs.name)
      if item?
        attrs.nickname = item.nickname
    results.push(attrs)
  for user_attribute in Analytics.Static.UserAttributes
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