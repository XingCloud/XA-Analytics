Analytics.Views.Reports ||= {}

class Analytics.Views.Reports.IndexView extends Backbone.View
  template: JST['backbone/templates/reports/report_list']

  initialize: (options) ->
    _.bindAll(this, "render")
    @reports = options.reports
    @categories = options.categories
    @reports.view = this

  render: () ->
    $(@el).html(@template(@reports.view_options(@categories)))
    $('#main-container').html($(@el))