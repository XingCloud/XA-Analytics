class Analytics.Collections.ReportCategories extends Backbone.Collection
  model : Analytics.Models.ReportCategory

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.report_category")
    if options?
      @project = options.project

  url: () ->
    if @project?
      "/projects/"+@project.id+"/report_categories"
    else
      "/template/report_categories"

  comparator: (report_category) ->
    if report_category.get("project_id")?
      1000 + report_category.get("position")
    else
      report_category.get("position")