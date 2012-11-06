class Analytics.Collections.UserAttributes extends Backbone.Collection
  model: Analytics.Models.UserAttribute

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.user_attribute")
    if options?
      @project = options.project

  url: () ->
    "/projects/" + @project.id + "/user_attributes"