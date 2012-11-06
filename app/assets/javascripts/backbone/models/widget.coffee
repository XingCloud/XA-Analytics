class Analytics.Models.Widget extends Backbone.Model
  defaults:
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
    project_widget = attributes.project_widget
    delete attributes["project_widget"]
    {widget: attributes, project_widget: project_widget}

  get_end_time: () ->
    @collection.end_time

  get_compare_end_time: () ->
    @collection.end_time

  get_dimension: () ->
    dimension = @get("dimension")
    _.find(Analytics.Static.getDimensions(), (item) -> item.value == dimension)