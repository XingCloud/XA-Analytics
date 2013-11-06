class Analytics.Models.Expression extends Backbone.Model
  defaults:
    value_type: Analytics.Static.user_attributes()[0].atype
    name: Analytics.Static.user_attributes()[0].name
    time_type: "absolute"

  value: (original_value) ->
    if @get("value_type") == "int" or @get("value_type") == "sql_bigint"
      parseInt(original_value)
    else
      original_value

  sqlvalue: (original_value) ->
    if @get("value_type") == "int" or @get("value_type") == "sql_bigint" # we only have three types of value: sql_string/sql_bigint/sql_datetime
        parseInt(original_value)                                         # more detailed type checking will be done at the backend.
    else
        "'"+original_value+"'"

  serialize: () ->
    result = {}
    if (@get("value_type") == "sql_datetime" or @get("value_type") == "Date") and @get("time_type") == "relative"
      value= @value(@get("value"))
      if @get("operator") == "eq"
        gte={"op":"gte", "expr":"$date_add(#{value})","type":"VAR"}
        lte={"op":"lte", "expr":"$date_add(#{value})","type":"VAR"}
        result[@get("name")] = [gte,lte]
      else # We will never encounter the situtation that operator is 'in' while time_type is "relative"
        result[@get("name")] = [{"op":@get("operator"), "expr":"$date_add(#{value})", "type":"VAR"}]
    else
      expression={"op":@get("operator")}
      expression["type"] = "CONST"
      result[@get("name")]=[expression]
      if @get("operator") == "in"
        expression["expr"] = (@value(item) for item in @get("value").split(",")).join("|")
      else
        expression["expr"] = @value(@get("value"))
    result


  serialize_to_sql: ()->
    op_map = {"gt":">","gte":">=","lt":"<","lte":"<=","eq":"=","in":"in"}
    operator = op_map[@get("operator")]
    value= @sqlvalue(@get("value"))
    if (@get("value_type") == "sql_datetime" or @get("value_type") == "Date") and @get("time_type") == "relative"
      if @get("operator") == "eq"
        "select uid from user where #{@get('name')} >= date_add('s',#{value}) and #{@get('name')} <= date_add('e',#{value});"
      else # We will never encounter the situtation that operator is 'in' while time_type is "relative"
        "select uid from user where #{@get('name')} #{operator} date_add(#{value});"
    else
      if @get("operator") == "in"
        "select uid from user where #{@get('name')} in (#{value});"
      else
        "select uid from user where #{@get('name')} #{operator} #{value};"
