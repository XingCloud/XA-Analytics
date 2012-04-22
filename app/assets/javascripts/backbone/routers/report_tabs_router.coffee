class Analytics.Routers.ReportTabsRouter extends Backbone.Router

  initialize: (project) ->
    @project = project
    @report_tabs = new Analytics.Collections.ReportTabs()
    @report_tabs.project = project

