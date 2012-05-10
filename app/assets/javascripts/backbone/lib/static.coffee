Analytics.Static ||= {}

Analytics.Static.UserAttributes = [
  {value: 'register_time', name: '注册时间', value_type: 'Date'},
  {value: 'last_login_time', name: '最后登陆时间', value_type: 'Date'},
  {value: 'first_pay_time', name: '首次付费时间', value_type: 'Date'},
  {value: 'last_pay_time', name: '最后付费时间', value_type: 'Date'},
  {value: 'grade', name: '等级', value_type: 'int'},
  {value: 'game_time', name: '游戏时间', value_type: 'int'},
  {value: 'pay_amount', name: '付费量', value_type: 'int'},
  {value: 'language', name: '语言', value_type: 'String'},
  {value: 'platform', name: '平台', value_type: 'String'}
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
  {value: "0", name: '事件字段第一层', dimension_type: 'EVENT', value_type: 'String'},
  {value: "1", name: '事件字段第二层', dimension_type: 'EVENT', value_type: 'String'},
  {value: "2", name: '事件字段第三层', dimension_type: 'EVENT', value_type: 'String'},
  {value: "3", name: '事件字段第四层', dimension_type: 'EVENT', value_type: 'String'},
  {value: "4", name: '事件字段第五层', dimension_type: 'EVENT', value_type: 'String'},
  {value: "5", name: '事件字段第六层', dimension_type: 'EVENT', value_type: 'String'}
]

Analytics.Static.Dimensions = [
  {value: 'register_time', name: '注册时间', dimension_type: "USER_PROPERTIES", value_type: 'Date'},
  {value: 'last_login_time', name: '最后登陆时间', dimension_type: "USER_PROPERTIES", value_type: 'Date'},
  {value: 'first_pay_time', name: '首次付费时间', dimension_type: "USER_PROPERTIES", value_type: 'Date'},
  {value: 'last_pay_time', name: '最后付费时间', dimension_type: "USER_PROPERTIES", value_type: 'Date'},
  {value: 'grade', name: '等级', dimension_type: "USER_PROPERTIES", value_type: 'int'},
  {value: 'game_time', name: '游戏时间', dimension_type: "USER_PROPERTIES", value_type: 'int'},
  {value: 'pay_amount', name: '付费量', dimension_type: "USER_PROPERTIES", value_type: 'int'},
  {value: 'language', name: '语言', dimension_type: "USER_PROPERTIES", value_type: 'String'},
  {value: 'platform', name: '平台', dimension_type: "USER_PROPERTIES", value_type: 'String'}
].concat(Analytics.Static.DimensionsEvents)

Analytics.Static.ReportTabIntervals = [
  {name: "分钟", value: "min5"},
  {name: "小时", value: "hour"},
  {name: "天", value: "day"},
  {name: "周", value: "week"},
  {name: "月", value: "month"}
]

Analytics.Static.ReportTabRanges = [
  {name: "实时", length: 1, interval: "min5"},
  {name: "今天", length: 1, interval: "hour"},
  {name: "最近两天", length: 2, interval: "hour"},
  {name: "最近一周", length: 7, interval: "day"},
  {name: "最近二周", length: 14, interval: "day"},
  {name: "最近一个月", length: 28, interval: "day"},
  {name: "最近二个月", length: 56, interval: "week"}
]

Analytics.Static.initUserAttributes = (user_attributes) ->
  if user_attributes? and user_attributes.length > 0
    Analytics.Static.UserAttributes = []
    Analytics.Static.Dimensions = [].concat(Analytics.Static.DimensionsEvents)
    for user_attribute in user_attributes
      Analytics.Static.UserAttributes.push({
        value: user_attribute.key
        name: user_attribute.name
        value_type: user_attribute.type
      })
      Analytics.Static.Dimensions.push({
        value: user_attribute.key
        name: user_attribute.name
        value_type: user_attribute.type
        dimension_type: 'USER_PROPERTIES'
      })