class Analytics.Collections.ActionLogs extends Backbone.Collection
  model: Analytics.Models.ActionLog

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.action_log")
    if options?
      @project = options.project
    @page = 1
    @fetched = true
    @max_page = 1

  comparator: (action_log) ->
    0 - Date.parse(action_log.get("perform_at"))

  url: () ->
    "/projects/" + @project.id + "/action_logs?page=" + @page

  parse: (response) ->
    @max_page = response.max_page
    response.action_logs