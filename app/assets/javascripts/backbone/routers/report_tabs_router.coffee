class Analytics.Routers.ReportTabsRouter extends Backbone.Router

  initialize: (options) ->
    @project = options.project
    @report_tabs = new Analytics.Collections.ReportTabs([])

