class Analytics.Models.ReportTab extends Backbone.Model
  defaults:
    chart_type: 'line'
    interval: 'day'
    length: 7
    compare: 0
    metric_ids: []

  initialize: (options) ->
    compare = new Date(new Date().getTime() - @get("length")*86400000)
    @compare_end_time = new Date(compare.getFullYear(), compare.getMonth(), compare.getDate())

  urlRoot: () ->
    if @get('project_id')?
      "/projects/"+@get('project_id')+'/reports/'+@get('report_id')+'/report_tabs'
    else
      "/template/reports/"+@get('report_id')+'/report_tabs'

  toJSON: () ->
    {report_tab: @attributes}

  data_url: () ->
    "/projects/"+project.id+"/reports/"+@get("report_id")+"/report_tabs/"+@id+"/data"

  show_attributes: () ->
    attributes = _.clone(@attributes)
    attributes.compare_end_time = @compare_end_time
    attributes
