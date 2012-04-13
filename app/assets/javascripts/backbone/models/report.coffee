class Analytics.Models.Report extends Backbone.Model
  initialize: (options) ->
    @report_tabs = new Analytics.Collections.ReportTabs()
    @set options
