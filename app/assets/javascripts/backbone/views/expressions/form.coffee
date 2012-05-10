Analytics.Views.Expressions ||= {}

class Analytics.Views.Expressions.FormView extends Backbone.View
  template: JST['backbone/templates/expressions/form']
  className: "expression"

  events:
    "click span#expression-remove" : "remove_expression"
    "change select.attributes-select" : "select_attribute"

  initialize: (options) ->
    _.bindAll(this, "render")
    @index = options.index
    @segment_form = options.parent

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @index
    $(@el).html(@template(attributes))
    this

  remove_expression: () ->
    @segment_form.remove_expression(this)

  select_attribute: (ev) ->
    value_type = $(ev.currentTarget).find('option:selected').attr('value_type')
    $(@el).find('.value-type').val(value_type)