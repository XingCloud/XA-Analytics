Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.NavView extends Backbone.View
  template: JST['backbone/templates/projects/left-menu']

  initialize: (options) ->
    _.bindAll(this, "render")
    @reports = options.reports
    @categories = options.categories
    @reports.bind "change", @render
    @reports.bind "add", @render
    @reports.bind "reset", @render
    @categories.bind "change", @render
    @categories.bind "add", @render
    @categories.bind "reset", @render


  render: () ->
    $(@el).html(@template(@reports.view_options(@categories)))