Analytics.Static ||= {}

Analytics.Static.UserAttributes = [
  {value: 'register_time', name: '注册时间'},
  {value: 'last_login_time', name: '最后登陆时间'},
  {value: 'first_pay_time', name: '首次付费时间'},
  {value: 'last_pay_time', name: '最后付费时间'},
  {value: 'grade', name: '等级'},
  {value: 'game_time', name: '游戏时间'},
  {value: 'pay_amount', name: '付费量'},
  {value: 'language', name: '语言'},
  {value: 'lplatforme', name: '平台'}
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

Analytics.Static.Dimensions = [
  {value: 'register_time', name: '注册时间', dimension_type: "USER_PROPERTIES"},
  {value: 'last_login_time', name: '最后登陆时间', dimension_type: "USER_PROPERTIES"},
  {value: 'first_pay_time', name: '首次付费时间', dimension_type: "USER_PROPERTIES"},
  {value: 'last_pay_time', name: '最后付费时间', dimension_type: "USER_PROPERTIES"},
  {value: 'grade', name: '等级', dimension_type: "USER_PROPERTIES"},
  {value: 'game_time', name: '游戏时间', dimension_type: "USER_PROPERTIES"},
  {value: 'pay_amount', name: '付费量', dimension_type: "USER_PROPERTIES"},
  {value: 'language', name: '语言', dimension_type: "USER_PROPERTIES"},
  {value: 'platform', name: '平台', dimension_type: "USER_PROPERTIES"},
  {value: "0", name: '事件字段第一层', dimension_type: 'EVENT'},
  {value: "1", name: '事件字段第二层', dimension_type: 'EVENT'},
  {value: "2", name: '事件字段第三层', dimension_type: 'EVENT'},
  {value: "3", name: '事件字段第四层', dimension_type: 'EVENT'},
  {value: "4", name: '事件字段第五层', dimension_type: 'EVENT'},
  {value: "5", name: '事件字段第六层', dimension_type: 'EVENT'}
]