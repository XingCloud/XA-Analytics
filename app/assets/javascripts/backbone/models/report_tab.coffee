class Analytics.Models.ReportTab extends Backbone.Model
  defaults:
    chart_type: 'line'
    interval: 'day'
    length: 7
    compare: 0
    start_time: $.format.date(new Date(), "yyyy/MM/dd")
    compare_start_time: $.format.date(new Date(new Date().getTime() - 7 * 86400000), "yyyy/MM/dd")
    metric_ids: []

  initialize: (options) ->
    @set options

  urlRoot: () ->
    if @get('project_id')?
      "/projects/"+@get('project_id')+'/reports/'+@get('report_id')+'/report_tabs'
    else
      "/template/reports/"+@get('report_id')+'/report_tabs'
