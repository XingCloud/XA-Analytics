Analytics.Views.UserAttributes ||= {}

class Analytics.Views.UserAttributes.RemoveView extends Backbone.View
  template: JST["backbone/templates/user_attributes/remove"]
  className: "modal"
  events:
    "click a.btn.submit" : "submit"
    "hidden" : "hidden"

  initialize: (options)->
    attribute = @model
    relative_expressions = _.filter(Instances.Collections.expressions.models, (model)-> model.get("name") == attribute.get("name"))

    @relative_segments = _.uniq(_.map(relative_expressions, (expression) -> Instances.Collections.segments.get(expression.get("segment_id"))), (segment)->segment.get("id"))
    relative_segment_ids = _.map(@relative_segments, (segment)->segment.get("id"))

    @relative_metrics =  _.filter(Instances.Collections.metrics.models, (model)->_.contains(relative_segment_ids,model.get("segment_id")))

  render: ()->
    $(@el).html(@template({relative_segments:@relative_segments, relative_metrics:@relative_metrics}))
    $(@el).modal()

  submit: (ev) ->
    for segments in @relative_segments
      segments.destroy({wait:true})

    for metric in @relative_metrics
      metric.destroy({wait:true})

    @model.destroy({wait: true})

  hidden: (ev) ->
    @remove()

