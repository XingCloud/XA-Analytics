class Analytics.Models.ProjectSummaryChart extends Backbone.Model

  initialize: (attributes, options) ->
    @set({sequence: {}})

  fetch_params: () ->
    switch @get("type")
      when "pay" then @pay_params()
      when "new_user" then @new_user_params()
      when "active" then @active_params()

  pay_params: () ->
    items:[
      name: "x"
      event_key: "pay.*.*.*.*.*"
      count_method: "SUM"
    ]
    formula: "x*0.01"
    id: @id
    start_time: @get("start_time")
    end_time: @get("end_time")
    interval: @get("interval")
    type: "COMMON"
    project_id: @get("project_id")

  new_user_params: () ->
    items:[
      name: "x"
      event_key: "visit.*.*.*.*.*"
      count_method: "USER_NUM"
      segment: '{"register_time":{"$handler":"DateSplittor","offset":0}}'
    ]
    formula: "x"
    id: @id
    start_time: @get("start_time")
    end_time: @get("end_time")
    interval: @get("interval")
    type: "COMMON"
    project_id: @get("project_id")

  active_params: () ->
    items:[
      name: "x"
      event_key: "visit.*.*.*.*.*"
      count_method: "USER_NUM"
      number_of_day: (if @get("interval") == "WEEK" then 7 else 0)
      number_of_day_origin: 0
    ]
    formula: "x"
    id: @id
    start_time: @get("start_time")
    end_time: @get("end_time")
    interval: "DAY"
    type: "COMMON"
    project_id: @get("project_id")

  safe_get: (sequence_field) ->
    if @get("sequence")? and @get("sequence")[sequence_field]?
      @get("sequence")[sequence_field]
    else
      "pending"

  safe_compare: (compare_chart, sequence_field) ->
    data0 = @safe_get(sequence_field)
    data1 = compare_chart.safe_get(sequence_field)
    if data0 != "pending" and data1 != "pending"
      if data0 == data1
        0
      else if data1 == 0
        "infinity"
      else
        (data0 - data1) / data1
    else
      "pending"