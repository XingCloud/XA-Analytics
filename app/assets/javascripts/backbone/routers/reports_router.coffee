class Analytics.Routers.ReportsRouter extends Backbone.Router
  routes:
    "/reports" : "index"
    "/reports/new" : "new"
    "/reports/:id" : "show"
    "/reports/:id/edit" : "edit"
    "/reports/:id/delete" : "delete"
    "/reports/:id/set_category/:category_id" : "set_category"

    "/template/reports" : "index"
    "/template/reports/new" : "template_new"
    "/template/reports/:id" : "template_show"
    "/template/reports/:id/edit" : "edit"
    "/template/reports/:id/delete" : "template_delete"
    "/template/reports/:id/set_category/:category_id" : "template_set_category"

  initialize: (project, options, category_options) ->
    @project = project
    @reports = new Analytics.Collections.Reports(options, category_options)
    @reports.project = project


  index: (project_id) ->
    if not @reports.view?
      new Analytics.Views.Reports.IndexView({id : "index_report", collection: @reports})
    @reports.view.render()


  show: (id) ->
    @do_show(@project.id, id)

  template_show: (id) ->
    @do_show(null, id)

  new: () ->
    report = new Analytics.Models.Report({
      project_id: @project.id,
      report_tabs_attributes: [new Analytics.Models.ReportTab({project_id: @project.id}).attributes]
    })
    report.collection = @reports
    new Analytics.Views.Reports.FormView({id : "new_report", model: report}).render()

  template_new: () ->
    report = new Analytics.Models.Report({
      project_id: null,
      report_tabs_attributes: [new Analytics.Models.ReportTab({project_id: null}).attributes]
    })
    report.collection = @reports
    new Analytics.Views.Reports.FormView({id : "new_report", model: report}).render()

  edit: (id) ->
    report = @reports.get(id)
    new Analytics.Views.Reports.FormView({id : "edit_report_"+report.id, model: report}).render()

  do_show: (project_id, id) ->
    report = @reports.get(id)
    if report?
      if not report.view?
        new Analytics.Views.Reports.ShowView({model: report, id : "report_"+id})
      report.view.render()
    else
      report = new Analytics.Models.Report({project_id : project_id, id : id})
      new Analytics.Views.Reports.ShowView({model: report, id : "#report_"+id})
      report.fetch({success: (model, resp) -> reports_router.reports.add(model)})
    $('#nav-accordion ul li').removeClass('active')
    $('#report'+id).addClass('active')





