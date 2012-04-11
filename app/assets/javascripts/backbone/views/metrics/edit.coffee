Analytics.Views.Metrics ||= {}

class Analytics.Views.Metrics.EditIndexView extends Backbone.View
  template: JST['backbone/templates/metrics/edit_index']
  tagName: 'div'
  className: 'metric_box'
  events:
    "click img.del" : "delete"

  initialize: () ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    @model.view = this

  render: () ->
    $(@el).html(@template({model : @model}))
    this

  delete: () ->
    $(@el).remove()
    @model.destroy()


class Analytics.Views.Metrics.EditListView extends Backbone.View
  initialize: () ->
    _.bindAll this, "addOne", "render"

  render: (metrics) ->
    if metrics.length > 0
      for i in [0..metrics.length-1]
        @addOne metrics.at(i)


  addOne: (metric) ->
    metric_view = new Analytics.Views.Metrics.EditIndexView({model: metric})
    $('#report_tab'+metric.get('tab_index')+'_metric_list').append metric_view.render().el
