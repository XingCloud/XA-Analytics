class Analytics.Routers.ReportsRouter extends Backbone.Router
  routes:
    "reports" : "index"
    "reports/new" : "new"
    "reports/:id" : "show"
    "reports/:id/edit" : "edit"
    "reports/:id/delete" : "delete"
    "reports/:id/set_category/:category_id" : "set_category"

  initialize: () ->

  can_access: (id) ->
    Instances.Models.user.can_access_report(parseInt(id))
      
  can_alter: () ->
    not Instances.Models.user.is_mgriant()

  is_system: (report) ->
    Instances.Models.project? and (not report.get("project_id")?) and report.get("report_category_id") == 2
    
  index: (project_id) ->
    if not Instances.Collections.reports.view?
      new Analytics.Views.Reports.IndexView({
        id : "index_report",
        reports: Instances.Collections.reports,
        categories: Instances.Collections.report_categories
      })
    Instances.Collections.reports.view.render()


  show: (id) ->
    if not @can_access(id)
      Analytics.Utils.redirect("404")
      return
    report = Instances.Collections.reports.get(id)
    if report?
      if not report.view?
        new Analytics.Views.Reports.ShowView({model: report, id : "report_"+id})
        report.view.render()
      else
        report.view.redraw()
      @highlight_report_nav(report)
    else
      Analytics.Utils.redirect("404")

  new: () ->
    $('div.report-panel').empty()
    if not @can_alter()
      Analytics.Utils.redirect("404")
      return
    if Instances.Models.project?
      report = new Analytics.Models.Report({project_id: Instances.Models.project.id})
    else
      report = new Analytics.Models.Report({})
    report.collection = Instances.Collections.reports
    new Analytics.Views.Reports.FormView({id : "new_report", model: report}).render()
    $('.nav-report').removeClass("active")

  edit: (id) ->
    $('div.report-panel').empty()
    if not @can_alter()
      Analytics.Utils.redirect("404")
      return    
    report = Instances.Collections.reports.get(id)
    if report? and not @is_system(report)
      new Analytics.Views.Reports.FormView({id : "edit_report_"+report.id, model: report}).render()
      @highlight_report_nav(report)
    else
      Analytics.Utils.redirect("404")

  delete: (id) ->
    if not @can_alter()
      Analytics.Utils.redirect("404")
      return
    report = Instances.Collections.reports.get(id)
    if report? and not @is_system(report)
     if confirm(I18n.t("commons.confirm_delete"))
        report.destroy({wait: true, success: (model, resp) ->
          Instances.Collections.reports.trigger "change"
          window.location.href = "#/dashboard"
        })
    else
      Analytics.Utils.redirect("404")

  set_category: (id, category_id) ->
    if not @can_alter()
      Analytics.Utils.redirect("404")
      return
    report = Instances.Collections.reports.get(id)
    if report? and not @is_system(report)
      report.set_category(category_id, {success: (resp, status, xhr) ->
        if Instances.Models.project?
          window.location.href = "#/reports/" + report.id
        else
          window.location.href = "#/reports"
      })
    else
      Analytics.Utils.redirect("404")

  highlight_report_nav: (report) ->
    $('.nav-dashboard li').removeClass("active")
    category_id = (if report.get("report_category_id")? then report.get("report_category_id") else 'unknown')
    if not $('#nav-category-'+category_id+"-body").hasClass("in")
      $('#nav-category-'+category_id).click()
    $('.nav-report').removeClass("active")
    $('#nav-report-'+report.id).addClass("active")
#    for category in $('#reports-accordion .accordion-group')
#      category = $(category)
#      cb = $(".accordion-body",category)
#      if cb.hasClass("in") and cb.attr('id') != 'nav-category-'+category_id+"-body"
#        $(".accordion-toggle", category).click()





