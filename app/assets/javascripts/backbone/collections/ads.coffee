class Analytics.Collections.Ads extends Backbone.Collection
  model : Analytics.Models.Ad

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.project_users")
    @project = options.project

  url: () ->
    "/projects/"+Instances.Models.project.id+'/ads'