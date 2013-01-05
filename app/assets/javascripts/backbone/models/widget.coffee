class Analytics.Models.Widget extends Backbone.Model
  defaults:
    widget_type: 'kpi'
    length: 7
    interval: 'day'

  urlRoot: () ->
    if Instances.Models.project?
      "/projects/" + Instances.Models.project.id + "/widgets"
    else
      "/template/widgets"

  toJSON: () ->
    attributes = _.clone(@attributes)
    project_widget = attributes.project_widget
    delete attributes["project_widget"]
    {widget: attributes, project_widget: project_widget}

  ###
  由 配置中的length和interval 自动决定end_time
  ###
  get_end_time: () ->
    now = new Date().getTime()
    ret = Analytics.Utils.validateDateRange(now, @get("length"),@get("interval"))
    if ret.result
      end_time = now
    else
      end_time = now - 86400000
    end_time
    #@collection.end_time

  get_compare_end_time: () ->
    @collection.end_time

  get_dimension: () ->
    dimension = @get("dimension")
    _.find(Analytics.Static.getDimensions(), (item) -> item.value == dimension)