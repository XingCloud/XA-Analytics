class Analytics.Models.Metric extends Backbone.Model
  initialize: (options) ->
    @set options

  edit_url: (tab_index) ->
    if @get('project_id')?
      "/projects/" + @get('project_id') + "/metrics/" + @get('id') + "/edit?tab_index="+tab_index
    else
      "/admin/template_metrics/" + @get('id') + "/edit?tab_index="+tab_index