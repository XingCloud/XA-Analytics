class Analytics.Routers.ReportsRouter extends Backbone.Router
  routes:
    "/reports" : "index"
    "/reports/new" : "new"
    "/reports/:id" : "show"
    "/reports/:id/clone" : "clone"
    "/reports/:id/edit" : "edit"
    "/reports/:id/delete" : "delete"
    "/reports/:id/set_category/:category_id" : "set_category"

  initialize: (options) ->
    @project = options.project
    @reports = new Analytics.Collections.Reports(options.reports)
    if @project?
      @templates = new Analytics.Collections.Reports(options.templates)
    @reports.project = options.project


  index: (project_id) ->
    if not @reports.view?
      new Analytics.Views.Reports.IndexView({
        id : "index_report",
        reports: @reports,
        categories: report_categories_router.categories
      })
    @reports.view.render()
    if @project?
      $('.reports-nav ul li').removeClass('active')


  show: (id) ->
    @do_show(@project.id, id)

  new: () ->
    if @project?
      report = new Analytics.Models.Report({project_id: @project.id})
    else
      report = new Analytics.Models.Report({})
    @do_new(report)

  edit: (id) ->
    if @project?
      $('.reports-nav ul li').removeClass('active')
      $('#nav-report'+id).addClass('active')
    report = @reports.get(id)
    if report?
      new Analytics.Views.Reports.FormView({id : "edit_report_"+report.id, model: report}).render()
    else
      window.location.href = "#/404"

  clone: (id) ->
    report = @templates.get(id)
    if report?
      report.clone({success: (resp, status, xhr) -> })
    else
      window.location.href = "#/404"

  delete: (id) ->
    report = @reports.get(id)
    if report?
     if confirm("确认删除报告"+report.get("title"))
        collection = @reports
        report.destroy({wait: true, success: (model, resp) ->
          collection.trigger "change"
          window.location.href = "#/reports"
        })
    else
      window.location.href = "#/404"

  set_category: (id, category_id) ->
    report = @reports.get(id)
    if report?
      report.set_category(category_id, {success: (resp, status, xhr) ->
        window.location.href = "#/reports"
      })
    else
      window.location.href = "#/404"

  do_show: (project_id, id) ->
    if @project?
      $('.reports-nav ul li').removeClass('active')
      $('#nav-report'+id).addClass('active')
    report = @reports.get(id)
    if not report?
      report = @templates.get(id)
    if report?
      if not report.view?
        new Analytics.Views.Reports.ShowView({model: report, id : "report_"+id})
        report.view.render()
      else
        report.view.redraw()
    else
      window.location.href = "#/404"

  do_new: (report) ->
    if @project?
      $('.reports-nav ul li').removeClass('active')
    report.collection = @reports
    new Analytics.Views.Reports.FormView({id : "new_report", model: report}).render()






