class Analytics.Collections.ReportCategories extends Backbone.Collection
  model : Analytics.Models.ReportCategory

  initialize: (options) ->
    for option in options
      @add new Analytics.Models.ReportCategory(option)