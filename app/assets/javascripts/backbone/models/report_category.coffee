class Analytics.Models.ReportCategory extends Backbone.Model
  urlRoot: () ->
    if @get('project_id')?
      "/projects/"+@get("project_id")+"/report_categories"
    else
      "/template/report_categories"

  shift: (action, options) ->
    success = options.success
    options.url = @urlRoot()+'/'+@id+'/shift_'+action
    model = this
    options.success =  (resp, status, xhr) ->
      model.collection.reset(resp)
      success(resp, status, xhr)
    Backbone.sync('read', this, options)

  toJSON: () ->
    {report_category: @attributes}