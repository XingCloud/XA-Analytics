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
      $('#nav-accordion ul li').removeClass('active')


  show: (id) ->
    @do_show(@project.id, id)

  new: () ->
    if @project?
      report = new Analytics.Models.Report({project_id: @project.id})
    else
      report = new Analytics.Models.Report({})
    report.collection = @reports
    new Analytics.Views.Reports.FormView({id : "new_report", model: report}).render()

  edit: (id) ->
    report = @reports.get(id)
    if report?
      new Analytics.Views.Reports.FormView({id : "edit_report_"+report.id, model: report}).render()
      if @project?
        $('#nav-accordion ul li').removeClass('active')
        $('#report'+id).addClass('active')
    else if window.history.length > 0
      window.history.back()
    else
      window.location.href = "#/reports"

  clone: (id) ->
    report = @templates.get(id)
    if report?
      report.clone({success: (resp, status, xhr) -> })
    else if window.history.length > 0
      window.history.back()
    else
      window.location.href = "#/reports"

  delete: (id) ->
    report = @reports.get(id)
    if report? and confirm("确认删除报告"+report.get("title"))
      collection = @reports
      report.destroy({wait: true, success: (model, resp) ->
        collection.trigger "change"
        window.location.href = "#/reports"
      })
    else
      window.location.href = "#/reports"

  set_category: (id, category_id) ->
    report = @reports.get(id)
    if report?
      report.set_category(category_id, {success: (resp, status, xhr) ->
        window.location.href = "#/reports"
      })
    else
      window.location.href = "#/reports"

  do_show: (project_id, id) ->
    report = @reports.get(id)
    if not report?
      report = @templates.get(id)
    if report?
      if not report.view?
        new Analytics.Views.Reports.ShowView({model: report, id : "report_"+id})
      report.view.redraw()
      $('#nav-accordion ul li').removeClass('active')
      $('#report'+id).addClass('active')





