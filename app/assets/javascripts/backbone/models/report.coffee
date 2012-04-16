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
