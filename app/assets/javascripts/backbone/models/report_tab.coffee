class Analytics.Models.ReportTab extends Backbone.Model

  headerView: null
  bodyView: null

  defaults:
    chart_type: 'line'

  initialize: (options) ->
    @set options

  add_metric_url: (tab_index) ->
    if not @get("project_id")?
      "/admin/template_metrics/new?tab_index="+tab_index
    else
      "/projects/"+@get("project_id")+"/metrics/new?tab_index="+tab_index
