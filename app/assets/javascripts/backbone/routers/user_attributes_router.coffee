class Analytics.Routers.UserAttributesRouter extends Backbone.Router

  initialize: (options) ->
    @project = options.project
    @user_attributes = new Analytics.Collections.UserAttributes(options.user_attributes)
    @user_attributes.project = options.project