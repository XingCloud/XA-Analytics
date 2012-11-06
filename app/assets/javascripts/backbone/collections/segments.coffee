class Analytics.Collections.Segments extends Backbone.Collection
  model : Analytics.Models.Segment

  initialize: (models, options) ->
    @resource_name = I18n.t("resources.segment")
    if options?
      @project = options.project

  selected: () ->
    (segment.id for segment in @filter((segment) -> segment.selected))

  reset_selected: (selected_ids) ->
    @each((segment) -> segment.selected = false)
    for id in selected_ids
      @get(id).selected = true

  url: () ->
    if @project?
      "/projects/"+@project.id+"/segments"
    else
      "/template/segments"

  init_expressions: () ->
    @each((segment) ->
      for expression_attributes in segment.get("expressions_attributes")
        expression = Instances.Collections.expressions.get(expression_attributes.id)
        if expression?
          expression.set(expression_attributes)
        else
          Instances.Collections.expressions.add(new Analytics.Models.ReportTab(expression_attributes))
    )