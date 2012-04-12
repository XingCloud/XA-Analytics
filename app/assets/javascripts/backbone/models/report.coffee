class Analytics.Models.Report extends Backbone.Model

  report_tabs: null

  initialize: (options) ->
    @report_tabs = new Analytics.Collections.ReportTabs()
    @set options
