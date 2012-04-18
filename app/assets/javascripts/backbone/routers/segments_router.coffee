class Analytics.Routers.SegmentsRouter extends Backbone.Router
  routes:
    "/segments" : "index"
    "/segments/new" : "new"
    "/segments/:id" : "show"
    "/segments/:id/edit" : "edit"
    "/segments/:id/delete" : "destroy"
    "/segments/toggle" : "toggle"


  initialize: (options) ->
    @segments = new Analytics.Collections.Segments()
    for option in options
      @segments.add(new Analytics.Models.Segment(option))

  index: () ->
    if project?
      if report?
        Analytics.Request.get '/projects/' + project.get("id") + "#/reports/" + report.get("id"), {}, (data) ->
      else
        Analytics.Request.get '/projects/' + project.get("id") , {}, (data) ->
          $("#container").html data
    else
      Analytics.Request.get '/admin/template_segments', {}, (data) ->
        $("#container").html data

  new: () ->
    if project?
      Analytics.Request.get 'projects/' + project.get("id") + '/segments/new',{}, (data) ->
        $("#container").html data
    else
      Analytics.Request.get '/admin/template_segments/new',{}, (data) ->
        $("#container").html data

  edit: (id) ->
    if project?
      Analytics.Request.get '/projects/'+project.get("id")+'/segments/' + id + '/edit', {}, (data) ->
        $('#container').html data
    else
      Analytics.Request.get '/admin/template_segments/' + id + '/edit', {}, (data) ->
        $('#container').html data

  create: (form_id) ->
    if project?
      Analytics.Request.post '/projects/' + project.get("id") + '/segments', $('#' + form_id).serialize(), (data) -> {}
      window.location.href = "#/reports/" + report.get("id")
    else
      Analytics.Request.post '/admin/template_segments', $('#' + form_id).serialize(), (data) -> {}
      window.location.href = "#/segments"


  update: (form_id, id) ->
    if project?
      Analytics.Request.put '/projects/' + project.get("id") + '/segments/' + id, $('#' + form_id).serialize(), (data) -> {}
      window.location.href = "#/reports/" + report.get("id")
    else
      Analytics.Request.put '/admin/template_segments/' + id, $('#' + form_id).serialize(), (data) -> {}
      window.location.href = "#/segments"


  destroy: (id) ->
    if confirm("确认删除？")
      if project?
        Analytics.Request.delete '/projects/' + project.get("id") + '/segments/' + id, {}, (data) -> {}
        window.location.href = "#/reports/" + report.get("id")
      else
        Analytics.Request.delete '/admin/template_segments/' + id, {}, (data) -> {}
        window.location.href = "#/segments"

