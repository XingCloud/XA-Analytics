class Analytics.Collections.ProjectSummaryCharts extends Analytics.Collections.BaseCharts
  model: Analytics.Models.ProjectSummaryChart
  chart_types: ["pay", "new_user", "active"]
  intervals: ["DAY", "WEEK"]

  initialize: (models, options) ->
    _.bindAll this, "fetch_charts"
    @project = options.project
    @view = options.view
    @no_data = false
    @last_request = {params: "", resp: "", success: true, time: 0}
    @bind "change", @change_view

  initialize_charts: () ->
    end_time = Analytics.Utils.pickUTCStart() - 86400000
    day_end_time_compare = end_time - 86400000
    week_start_time = end_time - 518400000
    week_end_time_compare = end_time - 604800000
    week_start_time_compare = week_end_time_compare - 518400000
    for type in @chart_types
      for interval in @intervals
        @add(new Analytics.Models.ProjectSummaryChart({
          id: type + "_" + interval + "_0"
          start_time: Analytics.Utils.formatUTCDate((if interval == "DAY" then end_time else week_start_time), "YYYY-MM-DD")
          end_time: Analytics.Utils.formatUTCDate(end_time, "YYYY-MM-DD")
          interval: interval
          project_id: @project.get("identifier")
          type: type
        }))
        @add(new Analytics.Models.ProjectSummaryChart({
          id: type + "_" + interval + "_1"
          start_time: Analytics.Utils.formatUTCDate((if interval == "DAY" then day_end_time_compare else week_start_time_compare), "YYYY-MM-DD")
          end_time: Analytics.Utils.formatUTCDate((if interval == "DAY" then day_end_time_compare else week_end_time_compare), "YYYY-MM-DD")
          interval: interval
          project_id: @project.get("identifier")
          type: type
        }))

  fetch_url: () ->
    "/projects/" + @project.id + "/timelines"

  fetch_params: () ->
    params = []
    @each((chart) -> params.push(chart.fetch_params()))
    {
      request: {params: JSON.stringify(params)}
      request_id: @project.get("identifier")
    }

  process_fetched_data: (resp) ->
    if not resp["data"]?
      false
    else if resp["err_code"]
      if resp["err_code"] != "ERR_36"
        false
      else
        @no_data = true
        true
    else
      contains_error = false
      for sequence in resp["data"]
        if not sequence.data? or sequence.data.length == 0
          contains_error = true
        chart = @get(sequence.id)
        _.extend(chart.get("sequence"), sequence)
      not contains_error

  has_pendings: () ->
    has = false
    @each((chart) ->
      if chart.get("sequence")?.natural == "pending"
        has = true
      if chart.get("sequence")?.total == "pending"
        has = true
      if (not has) and _.find(chart.get("sequence")["data"], (point) -> point[1] == "pending")
        has = true
    )
    has

  xa_id: () ->
    "summary." + @project.get("identifier")

  view_data: () ->
    data = {}
    for type in @chart_types
      field = (if type == "new_user" then "natural" else "total")
      data[type] = {
        count: @get(type + "_DAY_0").safe_get(field)
        compare_day: @get(type + "_DAY_0").safe_compare(@get(type + "_DAY_1"), field)
        compare_week: @get(type + "_WEEK_0").safe_compare(@get(type + "_WEEK_1"), field)
      }
    data

  change_view: () ->
    @view.redraw()

  get_project: () ->
    @project