class Analytics.Models.Report extends Backbone.Model
  defaults:
    "end_time": new Date()
    "start_time": new Date(new Date().getTime() - 1000 * 60 * 60 * 24 * 6)
    "compare": false
    "compare_end_time": new Date()
    "compare_start_time": new Date(new Date().getTime() - 1000 * 60 * 60 * 24 * 6)
    "rate": "day"

  initialize: (options) ->
    @report_tabs = new Analytics.Collections.ReportTabs()
    @set options

  ajax_params: (segments) ->
    params = []
    if not segments? or segments.length == 0
      segments = [{id: ""}]
    for segment in segments
      for metric in @get("report_tab").metrics
        params.push({
          "start_time": $.format.date(@get("start_time"), "yyyy-MM-dd"),
          "end_time": $.format.date(@get("end_time"), "yyyy-MM-dd"),
          "interval": @get("rate").toUpperCase(),
          "metric_id": metric.id,
          "segment_id": segment.id,
          "compare": false
        })
        if @get("compare")
          params.push({
            "start_time": $.format.date(@get("compare_start_time"), "yyyy-MM-dd"),
            "end_time": $.format.date(@get("compare_end_time"), "yyyy-MM-dd"),
            "interval": @get("rate").toUpperCase(),
            "metric_id": metric.id,
            "segment_id": segment.id,
            "compare": true
          })
    params
