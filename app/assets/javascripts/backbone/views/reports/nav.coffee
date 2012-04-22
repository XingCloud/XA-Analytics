Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.NavView extends Backbone.View
  template: JST['backbone/templates/projects/left-menu']

  initialize: () ->
    _.bindAll(this, "render")
    @collection.bind "change", @render
    @collection.bind "add", @render
    @collection.bind "reset", @render
    @collection.categories.bind "change", @render
    @collection.categories.bind "add", @render
    @collection.categories.bind "reset", @render


  render: () ->
    $('#report-nav-list').html(@template(@collection.view_options()))