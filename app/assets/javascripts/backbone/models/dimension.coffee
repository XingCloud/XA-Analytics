class Analytics.Models.Dimension extends Backbone.Model
  defaults:
    name: Analytics.Static.UserAttributes[0].nickname
    value: Analytics.Static.UserAttributes[0].name
    dimension_type: "USER_PROPERTIES"

  serialize: (value) ->
    result = {}
    if @get("value_type") == "int" or @get("value_type") == "sql_bigint"
      result[@get("value")] = parseInt(value)
    else
      result[@get("value")] = value
    result
