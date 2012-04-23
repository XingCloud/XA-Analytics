class Analytics.Models.Project extends Backbone.Model
  first_report: () ->
    report = null
    if @get("template_report_categories").length
      for report_category in @get("template_report_categories")
        if report_category.reports.length
          report = report_category.reports[0]
          break
    if not report? and @get('template_reports').length
      report = @get('template_reports')[0]
    if not report? and @get("report_categories").length
      for report_category in @get("report_categories")
        if report_category.reports.length
          report = report_category.reports[0]
          break
    if not report? and @get("reports").length
      report = @get('reports')[0]
    report