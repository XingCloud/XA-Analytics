window.project = new Analytics.Models.Project()
window.reports_router = new Analytics.Routers.ReportsRouter();
window.report_categories_router = new Analytics.Routers.ReportCategoriesRouter()
window.report_tabs_router = new Analytics.Routers.ReportTabsRouter()
window.metrics_router = new Analytics.Routers.MetricsRouter()
Backbone.history.start();