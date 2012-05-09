class Analytics.Models.Project extends Backbone.Model

  initialize: (options) ->
    now = Analytics.Utils.UTCDate(new Date().getTime())
    @report_end_time = new Date(now.getFullYear(), now.getMonth(), now.getDate()).getTime()

  first_report: () ->
    if reports_router.templates.length > 0
      return reports_router.templates.last()
    else
      return reports_router.reports.last()

  show_attributes: () ->
    attributes = _.clone(@attributes)
    attributes.report_end_time = @report_end_time
    attributes