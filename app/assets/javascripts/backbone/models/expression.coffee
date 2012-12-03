class Analytics.Models.Expression extends Backbone.Model
  defaults:
    value_type: Analytics.Static.user_attributes()[0].atype
    name: Analytics.Static.user_attributes()[0].name

  value: () ->
    if @get("value_type") == "int" or @get("value_type") == "sql_bigint"
      parseInt(@get("value"))
    else
      @get("value")

  serialize: () ->
    result = {}
    operator = @get("operator")
    if operator == "eq"
      result[@get("name")] = @value()
    else if operator == "handler"
      result[@get("name")] = {"$handler": "DateSplittor"}
      if @get("value")? and @get("value").length > 0
        result[@get("name")]["offset"] = parseInt(@get("value"))
      else
        result[@get("name")]["offset"] = 0
    else
      result[@get("name")] = {}
      result[@get("name")]["$"+operator] = @value()
    result

