class Analytics.Routers.ReportCategoriesRouter extends Backbone.Router
  routes:
    "/report_categories/new" : "new"
    "/report_categories/edit/:id" : "edit"
    "/report_categories/delete/:id" : "delete"
    "/report_categories/shift_up/:id" : "shift_up"
    "/report_categories/shift_down/:id" : "shift_down"

  new: () ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/report_categories/new', {} , (data) ->
        $('#container').html(data)
    else
      Analytics.Request.get '/admin/template_report_categories/new', {} , (data) ->
        $('#container').html(data)

  edit: (id) ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/report_categories/'+id+'/edit/', {} , (data) ->
        $('#container').html(data)
    else
      Analytics.Request.get '/admin/template_report_categories/'+id+'/edit/', {} , (data) ->
        $('#container').html(data)

  create: (form_id) ->
    if project?
      Analytics.Request.post '/projects/'+project.get("id")+'/report_categories', $('#'+form_id).serialize(), (data) -> {}
    else
      Analytics.Request.post '/admin/template_report_categories', $('#'+form_id).serialize(), (data) -> {}

    window.location.href = "#/reports"

  update: (form_id, id) ->
    if project?
      Analytics.Request.put '/projects/'+project.get("id")+'/report_categories/'+id, $('#'+form_id).serialize(), (data) -> {}
    else
      Analytics.Request.put '/admin/template_report_categories/'+id, $('#'+form_id).serialize(), (data) -> {}

    window.location.href = "#/reports"

  delete: (id) ->
    if confirm('确认删除？')
      if project?
        Analytics.Request.delete '/projects/'+project.get("id")+'/report_categories/'+id, {}, (data) -> {}
      else
        Analytics.Request.delete '/admin/template_report_categories/'+id, {}, (data) -> {}

    window.location.href = "#/reports"

  shift_up: (id) ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/report_categories/'+id+'/shift_up', {}, (data) -> {}
    else
      Analytics.Request.get '/admin/template_report_categories/'+id+'/shift_up', {}, (data) -> {}

    window.location.href = "#/reports"

  shift_down: (id) ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/report_categories/'+id+'/shift_down', {}, (data) -> {}
    else
      Analytics.Request.get '/admin/template_report_categories/'+id+'/shift_down', {}, (data) -> {}

    window.location.href = "#/reports"