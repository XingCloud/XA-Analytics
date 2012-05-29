class Analytics.Collections.Widgets extends Backbone.Collection
  model: Analytics.Models.Widget

  initialize: (options) ->
    @synced = false
    @project = options.project
    now = new Date().getTime()
    @end_time = now - now % 86400000

  url: () ->
    if @project?
      "/projects/"+@project.id+"/widgets"
    else
      "/template/widgets"

  sync_server: (options) ->
    collection = this
    if not @synced
      @fetch({
        success: (resp) ->
          collection.synced = true
          options.success(resp)
      })
    else
      options.success()