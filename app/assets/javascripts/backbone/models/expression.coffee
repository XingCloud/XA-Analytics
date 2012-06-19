class Analytics.Models.Expression extends Backbone.Model
  defaults:
    value_type: Analytics.Static.UserAttributes[0].value_type
    name: Analytics.Static.UserAttributes[0].value

  value: () ->
    if @get("value_type") == "int"
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
    else
      result[@get("name")] = {}
      result[@get("name")]["$"+operator] = @value()
    result

