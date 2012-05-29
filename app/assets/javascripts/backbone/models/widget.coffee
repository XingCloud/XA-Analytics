class Analytics.Models.Widget extends Backbone.Model
  defaults:
    title: '新建小窗口'
    widget_type: 'kpi'
    length: 7
    interval: 'day'

  urlRoot: () ->
    if @get("project_id")?
      "/projects/"+@get("project_id")+"/widgets"
    else
      "/template/widgets"

  toJSON: () ->
    attributes = _.clone(@attributes)
    delete attributes["display"]
    delete attributes["position"]
    {widget: attributes}

  get_end_time: () ->
    @collection.end_time

  get_compare_end_time: () ->
    @collection.end_time