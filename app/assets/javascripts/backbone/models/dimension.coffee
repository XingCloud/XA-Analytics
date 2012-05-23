class Analytics.Models.Dimension extends Backbone.Model
  defaults:
    name: Analytics.Static.Dimensions[0].name
    value: Analytics.Static.Dimensions[0].value
    dimension_type: Analytics.Static.Dimensions[0].dimension_type

  serialize: (value) ->
    result = {}
    if @get("value_type") == "int"
      result[@get("value")] = parseInt(value)
    else
      result[@get("value")] = value
    result
