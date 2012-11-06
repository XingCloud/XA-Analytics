class Analytics.Routers.ReportsRouter extends Backbone.Router
  routes:
    "/reports" : "index"
    "/reports/new" : "new"
    "/reports/:id" : "show"
    "/reports/:id/edit" : "edit"
    "/reports/:id/delete" : "delete"
    "/reports/:id/set_category/:category_id" : "set_category"

  initialize: () ->

  index: (project_id) ->
    if not Instances.Collections.reports.view?
      new Analytics.Views.Reports.IndexView({
        id : "index_report",
        reports: Instances.Collections.reports,
        categories: Instances.Collections.report_categories
      })
    Instances.Collections.reports.view.render()


  show: (id) ->
    report = Instances.Collections.reports.get(id)
    if report?
      if not report.view?
        new Analytics.Views.Reports.ShowView({model: report, id : "report_"+id})
        report.view.render()
      else
        report.view.redraw()
      @highlight_report_nav(report)
    else
      window.location.href = "#/404"

  new: () ->
    if Instances.Models.project?
      report = new Analytics.Models.Report({project_id: Instances.Models.project.id})
    else
      report = new Analytics.Models.Report({})
    report.collection = Instances.Collections.reports
    new Analytics.Views.Reports.FormView({id : "new_report", model: report}).render()
    $('.nav-report').removeClass("active")

  edit: (id) ->
    report = Instances.Collections.reports.get(id)
    if report?
      new Analytics.Views.Reports.FormView({id : "edit_report_"+report.id, model: report}).render()
      @highlight_report_nav(report)
    else
      window.location.href = "#/404"

  delete: (id) ->
    report = Instances.Collections.reports.get(id)
    if report?
     if confirm(I18n.t("commons.confirm_delete"))
        report.destroy({wait: true, success: (model, resp) ->
          Instances.Collections.reports.trigger "change"
          Analytics.Utils.actionFinished()
        })
    else
      window.location.href = "#/404"

  set_category: (id, category_id) ->
    report = Instances.Collections.reports.get(id)
    if report?
      report.set_category(category_id, {success: (resp, status, xhr) ->
        if Instances.Models.project?
          window.location.href = "#/reports/" + report.id
        else
          window.location.href = "#/reports"
      })
    else
      window.location.href = "#/404"

  highlight_report_nav: (report) ->
    category_id = (if report.get("report_category_id")? then report.get("report_category_id") else 'unknown')
    if not $('#nav-category-'+category_id+"-body").hasClass("in")
      $('#nav-category-'+category_id).click()
    $('.nav-report').removeClass("active")
    $('#nav-report-'+report.id).addClass("active")
    for category in $('#reports-accordion .accordion-group')
      category = $(category)
      cb = $(".accordion-body",category)
      if cb.hasClass("in") and cb.attr('id') != 'nav-category-'+category_id+"-body"
        $(".accordion-toggle", category).click()





