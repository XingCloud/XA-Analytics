class Analytics.Models.Dimension extends Backbone.Model
  defaults:
    value: Analytics.Static.user_attributes()[0].name
    dimension_type: "USER_PROPERTIES"

  serialize: (value) ->
    result = {}
    if @get("value_type") == "int" or @get("value_type") == "sql_bigint"
      if value.indexOf("≥") != -1
        result[@get("value")] = [{"op":"gte", "expr":parseInt(value.replace("≥", "")), "type":"CONST"}]
      else if value.indexOf("<") != -1
        result[@get("value")] = [{"op":"lte", "expr":parseInt(value.replace("<", "")), "type":"CONST"}]
      else if value.indexOf("-") != -1
        splits = value.split("-")
        result[@get("value")] = [{"op":"gte", "expr":parseInt(splits[0]), "type":"CONST"},{"op":"lte", "expr":parseInt(splits[1]), "type":"CONST"}]
      else
        result[@get("value")] = [{"op":"eq", "expr":parseInt(value), "type":"CONST"}]
    else
      result[@get("value")] = [{"op":"eq", "expr":value, "type":"CONST"}]
    result

  serialize_to_sql: (value) ->
    if @get("value_type") == "int" or @get("value_type") == "sql_bigint"
      if value.indexOf("≥") != -1
        value = parseInt(value.replace("≥", ""))
        "select uid from user where #{@get('value')} >= #{value};"
      else if value.indexOf("<") != -1
        value = parseInt(value.replace("<", ""))
        "select uid from user where #{@get('value')} < #{value};"
      else if value.indexOf("-") != -1
        splits = value.split("-")  # "a-b"
        value0 = parseInt(splits[0])
        value1 = parseInt(splits[1])
        "select uid from user where #{@get('value')} >= #{value0} and #{@get('value')} <= #{value1}};"
      else
        value = parseInt(value)
        "select uid from user where #{@get('value')} = #{value};"
    else
      "select uid from user where #{@get('value')} = '#{value}';"