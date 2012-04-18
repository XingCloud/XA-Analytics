class Analytics.Routers.ReportsRouter extends Backbone.Router
  routes:
    "" : "dashboard"
    "/reports" : "index"
    "/reports/new" : "new"
    "/reports/:id" : "show"
    "/reports/:id/edit" : "edit"
    "/reports/:id/delete" : "delete"
    "/reports/:id/set_category/:category_id" : "set_category"
    "/reports/:id/report_tabs/:report_tab_id" : "choose_tab"
    "/reports/:id/toggle": "toggle"


  initialize: () ->
    @reports = new Analytics.Collections.Reports()

  dashboard: () ->
    Analytics.Request.get '/projects/'+project.get("id")+'/dashboard', {}, (data) ->
      $('#container').html data

  index: () ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/reports', {}, (data) ->
        $('#container').html data
    else
      Analytics.Request.get '/admin/template_reports', {}, (data) ->
        $('#container').html data

  new: () ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/reports/new', {}, (data) ->
        $('#container').html data
    else
      Analytics.Request.get '/admin/template_reports/new', {}, (data) ->
        $('#container').html data

  edit: (id) ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/reports/'+id+'/edit', {}, (data) ->
        $('#container').html data
    else
      Analytics.Request.get '/admin/template_reports/'+id+'/edit', {}, (data) ->
        $('#container').html data

  show: (id) ->
    $('.nav.nav-list li').removeClass('active')
    $('#report'+id).addClass('active')
    Analytics.Request.get '/projects/'+project.get("id")+'/reports/'+id, {}, (data) ->
      $('#container').html data

  create: (form_id) ->
    if project?
      Analytics.Request.post '/projects/'+project.get("id")+'/reports', $('#'+form_id).serialize(), (data) ->
        window.location.href = "#/reports/"+data["id"]
    else
      Analytics.Request.post '/admin/template_reports', $('#'+form_id).serialize(), (data) ->
        window.location.href = "#/reports"

  update: (form_id, id) ->
    if project?
      Analytics.Request.put '/projects/'+project.get("id")+'/reports/'+id, $('#'+form_id).serialize(), (data) ->
        window.location.href = "#/reports/"+data["id"]
    else
      Analytics.Request.put '/admin/template_reports/'+id, $('#'+form_id).serialize(), (data) ->
        window.location.href = "#/reports"

  delete: (id) ->
    if confirm("确认删除？")
      if project?
        Analytics.Request.delete '/projects/'+project.get("id")+'/reports/'+id, {}, (data) -> {}
      else
        Analytics.Request.delete '/admin/template_reports/'+id, {}, (data) -> {}

    window.location.href = "#/reports"

  set_category: (id, category_id) ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/reports/'+id+'/set_category', {report_category_id : category_id}, (data) -> {}
    else
      Analytics.Request.get '/admin/template_reports/'+id+'/set_category', {report_category_id : category_id}, (data) -> {}

    window.location.href = "#/reports"

  choose_tab: (id, report_tab_id) ->
    Analytics.Request.get '/projects/'+project.get("id")+'/reports/'+id, {"report_tab_id": report_tab_id}, (data) ->
      $('#container').html data

  report: (options) ->
    report = @reports.find((item) -> item.id == options["id"])
    old_options = {}
    if report?
      old_options = report.attributes
      @reports.remove report
      report.view.destroy()
    new_report = new Analytics.Models.Report(old_options)
    new_report.set(options)
    new Analytics.Views.Reports.ShowView({model: new_report})
    new_report.view.render()
    @reports.add new_report
    new_report
