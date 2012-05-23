class Analytics.Collections.ReportCategories extends Backbone.Collection
  model : Analytics.Models.ReportCategory

  comparator: (report_category) ->
    report_category.get("position")