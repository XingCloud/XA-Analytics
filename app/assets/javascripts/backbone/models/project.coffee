class Analytics.Models.Project extends Backbone.Model
  defaults:
    user_count: 0
    report_count: 0
    metric_count: 0
    segment_count: 0
    action_logs: []

  initialize: (options) ->
    @fetched = false

  url: () ->
    "/projects/" + @id + "/description"

  first_report: () ->
    Instances.Collections.reports.first()

  first_can_access_report: () ->
    _.find(Instances.Collections.reports.models, (report)-> Instances.Models.user.can_access_report(report.id))

  loading: () ->
    @load_resources(@)

  load_resources: (project) ->
    init_view = new Analytics.Views.Projects.InitView()
    init_view.render()
    count = 0
    Instances.Collections = {
      user_attributes: new Analytics.Collections.UserAttributes([], {project: project})
      segments: new Analytics.Collections.Segments([], {project: project})
      expressions: new Analytics.Collections.Expressions([], {project: project})
      report_categories: new Analytics.Collections.ReportCategories([], {project: project})
      reports: new Analytics.Collections.Reports([], {project: project})
      report_tabs: new Analytics.Collections.ReportTabs([], {project: project})
      widgets: new Analytics.Collections.Widgets([], {project: project})
      metrics: new Analytics.Collections.Metrics([], {project: project})
      translations: new Analytics.Collections.Translations([], {project: project})
      user_preferences: new Analytics.Collections.UserPreferences()
      project_users: new Analytics.Collections.ProjectUsers([], {project:project})
      ads: new Analytics.Collections.Ads([], {project:project})
    }
    total = _.select(Instances.Collections, (instance) -> instance.url?).length
    load_finished = @load_finished
    _.each(Instances.Collections, (instance) ->
      if instance.url?
        instance.fetch({
        error: () ->
          init_view.render_init_error()
        success: () ->
          count = count + 1
          init_view.render_init_success(I18n.t("commons.loaded")+instance.resource_name+"...", count / total)
          if count == total
            load_finished(project)
        })
    )
    Instances.Collections.action_logs = new Analytics.Collections.ActionLogs([], {project: this})

  load_finished: (project) ->
    Instances.Collections.translations.attach_translation()
    Instances.Models.user.set_project_user() #todo:必须在render所有view之前执行,因为要做权限判断(其实可以在服务器端完成)
    new Analytics.Views.Projects.ShowView({model: project}).render()
    Instances.Routers = {
      report_categories_router: new Analytics.Routers.ReportCategoriesRouter(),
      reports_router: new Analytics.Routers.ReportsRouter(),
      segments_router: new Analytics.Routers.SegmentsRouter(),
      widgets_router: new Analytics.Routers.WidgetsRouter(),
      projects_router: new Analytics.Routers.ProjectsRouter()
    }
    need_redirect = (location.href.indexOf('#') == -1 or location.href.indexOf('#') + 1 >= location.href.length)
    if Analytics.Utils.checkPushState()
      Backbone.history.start({pushState: true, root: window.ROOT})
    else
      Backbone.history.start()
    if need_redirect
      Analytics.Utils.redirect("dashboard")