class Analytics.Collections.Metrics extends Backbone.Collection
  model: Analytics.Models.Metric

  initialize: (options) ->
    for option in options
      @add new Analytics.Models.Metric(option)