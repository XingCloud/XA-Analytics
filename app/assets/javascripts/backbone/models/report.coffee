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

  ajax_attrs: () ->
    {
      "start_time": $.format.date(@get("start_time"), "yyyy-MM-dd")
      "end_time": $.format.date(@get("end_time"), "yyyy-MM-dd")
      "compare_start_time": $.format.date(@get("compare_start_time"), "yyyy-MM-dd")
      "compare_end_time": $.format.date(new Date(@get("compare_start_time").getTime()+@get("end_time").getTime()-@get("start_time").getTime()), "yyyy-MM-dd")
      "rate": @get("rate")
      "compare": @get("compare")
    }
