class Analytics.Routers.ReportsRouter extends Backbone.Router
  routes:
    "/reports" : "index"
    "/reports/new" : "new"
    "/reports/:id" : "show"
    "/reports/:id/edit" : "edit"
    "/reports/:id/delete" : "delete"
    "/reports/:id/set_category/:category_id" : "set_category"


  initialize: (options) ->
    @reports = new Analytics.Collections.Reports()
    for option in options
      @reports.add(new Analytics.Models.Report(option))

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
    alert "haha"

  create: (form_id) ->
    if project?
      Analytics.Request.post '/projects/'+project.get("id")+'/reports', $('#'+form_id).serialize(), (data) -> {}
    else
      Analytics.Request.post '/admin/template_reports', $('#'+form_id).serialize(), (data) -> {}

    window.location.href = "#/reports"

  update: (form_id, id) ->
    if project?
      Analytics.Request.put '/projects/'+project.get("id")+'/reports/'+id, $('#'+form_id).serialize(), (data) -> {}
    else
      Analytics.Request.put '/admin/template_reports/'+id, $('#'+form_id).serialize(), (data) -> {}

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