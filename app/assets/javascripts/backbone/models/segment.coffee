class Analytics.Models.Segment extends Backbone.Model

  initialize: (options) ->
    @expressions = []
    @selected = false
    if options? and options.expressions_attributes?
      for expression_attributes in options.expressions_attributes
        @expressions.push(new Analytics.Models.Expression(expression_attributes))

  form_attributes: () ->
    attributes = _.clone(@attributes)
    attributes.expressions_attributes = []
    for expression in @expressions
      attributes.expressions_attributes.push(expression.attributes)
    attributes

  parse: (resp) ->
    if resp.expressions_attributes?
      delete_expression_indexes = []
      for expression in @expressions
        if not _.find(resp.expressions_attributes, (item) -> item.id == expression.id)?
          delete_expression_indexes.push(@expressions.indexOf(expression))
      for expression_index in delete_expression_indexes
        @expressions.splice(expression_index, 1)
      for expression_attributes in resp.expressions_attributes
        expression = _.find(@expressions, (item) -> item.id == expression_attributes.id)
        if expression?
          expression.set(expression_attributes)
        else
          @expressions.push(new Analytics.Models.Expression(expression_attributes))
    resp

  urlRoot: () ->
    if @get('project_id')?
      "/projects/"+@get('project_id')+'/segments'
    else
      "/template/segments"

  toJSON: () ->
    {segment: @attributes}

  serialize: () ->
    if @expressions.length > 0
      results = {}
      for expression in @expressions
        _.extend(results, expression.serialize())
      results