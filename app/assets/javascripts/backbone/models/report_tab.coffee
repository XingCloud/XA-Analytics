class Analytics.Models.ReportTab extends Backbone.Model

  headerView: null
  bodyView: null

  defaults:
    chart_type: 'line'

  initialize: (options) ->
    @set options

  add_metric_url: (tab_index) ->
    if not project?
      "/admin/template_metrics/new?tab_index="+tab_index
    else
      "/projects/"+project.id+"/metrics/new?tab_index="+tab_index
