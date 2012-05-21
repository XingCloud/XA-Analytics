class Analytics.Models.Project extends Backbone.Model

  initialize: (options) ->

  first_report: () ->
    if reports_router.templates.length > 0
      return reports_router.templates.first()
    else
      return reports_router.reports.first()