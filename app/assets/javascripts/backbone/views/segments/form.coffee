Analytics.Views.Segments ||= {}
class Analytics.Views.Segments.FormView extends Backbone.View
  template: JST['backbone/templates/segments/form']
  className: 'segment-form'

  events:
    "click span#expression-add" : "add_expression"
    "click a#submit-segment" : "submit_segment"
    "click a#submit-segment-cancel" : "submit_segment_cancel"

  initialize: (options) ->
    _.bindAll(this, "render")
    @list_view = options.parent
    @index = 0
    @count = 0

  render: () ->
    $(@el).html(@template(@model.form_attributes()))

    for expression_attributes in @model.get("expressions_attributes")
      expression = Instances.Collections.expressions.get(expression_attributes.id)
      @render_expression(expression)

    if @model.get("expressions_attributes").length == 0 and Instances.Models.project?
      @render_expression(new Analytics.Models.Expression())

    this

  render_expression: (expression) ->
    $(@el).find('.expression-add').before(new Analytics.Views.Expressions.FormView({
      model: expression,
      index: @index,
      parent: this
    }).render().el)
    @index = @index + 1
    @count = @count + 1

  remove_expression: (expression_view) ->
    if @count > 1 or not @model.get("project_id")?
      $(expression_view.el).hide()

  add_expression: () ->
    @render_expression(new Analytics.Models.Expression())

  submit_segment: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      collection = @model.collection
      update = @model.id?
      @model.save(@form_attributes(), {
        wait: true,
        slient: true,
        success: (model, resp) ->
          if update
            model.selected = true
            collection.trigger("change")
          else
            model.selected = true
            collection.add(model)
      })

  submit_segment_cancel: () ->
    @remove()
    @list_view.redraw()

  form_attributes: () ->
    form = $(@el).find('form').toJSON()
    expressions_attributes = form.expressions_attributes
    form_attributes = _.clone(form)
    form_attributes.expressions_attributes = []
    _.each(expressions_attributes, (expression_attributes) ->
      if expression_attributes?
        form_attributes.expressions_attributes.push(expression_attributes)
    )
    form_attributes
