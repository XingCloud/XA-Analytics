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
    widget_connector = attributes.widget_connector
    delete attributes["widget_connector"]
    {widget: attributes, widget_connector: widget_connector}

  get_end_time: () ->
    @collection.end_time

  get_compare_end_time: () ->
    @collection.end_time

  get_dimension: () ->
    dimension = @get("dimension")
    _.find(Analytics.Static.Dimensions, (item) -> item.value == dimension)