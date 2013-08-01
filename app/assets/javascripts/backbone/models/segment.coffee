class Analytics.Models.Segment extends Backbone.Model

  initialize: (options) ->
    @selected = false
    if not @get("expressions_attributes")?
      @set({expressions_attributes: []})

  form_attributes: () ->
    attributes = _.clone(@attributes)
    attributes

  parse: (resp) ->
    if resp.expressions_attributes?
      for expression_attributes in resp.expressions_attributes
        expression = Instances.Collections.expressions.get(expression_attributes.id)
        if expression?
          expression.set(expression_attributes)
        else
          Instances.Collections.expressions.add(new Analytics.Models.Expression(expression_attributes))
    resp

  urlRoot: () ->
    if Instances.Models.project?
      "/projects/"+Instances.Models.project.id+'/segments'
    else
      "/template/segments"

  toJSON: () ->
    {segment: @attributes}

  serialize: () ->
    if @get("expressions_attributes").length > 0
      results = {}
      for expression_attributes in @get("expressions_attributes")
        expression = Instances.Collections.expressions.get(expression_attributes.id)
        serialize = results[expression.get("name")]
        if serialize?
          results[expression.get("name")]=_.union(serialize, expression.serialize()[expression.get("name")])
        else
          _.extend(results, expression.serialize())
      results