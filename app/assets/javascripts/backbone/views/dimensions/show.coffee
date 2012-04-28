Analytics.Views.Dimensions ||= {}

class Analytics.Views.Dimensions.ShowView extends Backbone.View
  template: JST['backbone/templates/dimensions/show']

  initialize: (options) ->
    _.bindAll(this, "render")
    @stack = []
    @report_tab = options.report_tab

  render: () ->
    if @model.get("dimensions").length > 0
      $(@el).html(@template(@model.attributes))
    this