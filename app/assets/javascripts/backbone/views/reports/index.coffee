Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.IndexView extends Backbone.View
  template: JST['backbone/templates/reports/list']
  collection: Analytics.Collections.Reports

  initialize: () ->
    _.bindAll(this, "render")
    @collection.view = this

  render: () ->
    $(@el).html(@template(@collection.view_options()))
    $('#main-container').html($(@el))