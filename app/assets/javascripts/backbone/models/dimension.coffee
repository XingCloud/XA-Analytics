class Analytics.Models.Dimension extends Backbone.Model
  defaults:
    name: Analytics.Static.user_attributes()[0].nickname
    value: Analytics.Static.user_attributes()[0].name
    dimension_type: "USER_PROPERTIES"

  serialize: (value) ->
    result = {}
    if @get("value_type") == "int" or @get("value_type") == "sql_bigint"
      if value.indexOf("≥") != -1
        result[@get("value")] = {"$gte": parseInt(value.replace("≥", ""))}
      else if value.indexOf("<") != -1
        result[@get("value")] = {"$lte": parseInt(value.replace("<", ""))}
      else if value.indexOf("-") != -1
        splits = value.split("-")
        result[@get("value")] = {"$gte": parseInt(splits[0]), "$lte": parseInt(splits[1])}
      else
        result[@get("value")] = parseInt(value)
    else
      result[@get("value")] = value
    result
