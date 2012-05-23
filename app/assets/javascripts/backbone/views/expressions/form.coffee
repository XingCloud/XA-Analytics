Analytics.Views.Expressions ||= {}

class Analytics.Views.Expressions.FormView extends Backbone.View
  template: JST['backbone/templates/expressions/form']
  className: "expression"

  events:
    "click span#expression-remove" : "remove_expression"
    "change select.attributes-select" : "select_attribute"
    "change select.operator-select" : "select_operator"

  initialize: (options) ->
    _.bindAll(this, "render", "redraw")
    @index = options.index
    @segment_form = options.parent

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.index = @index
    $(@el).html(@template(attributes))
    @render_datepicker()
    this

  redraw: (attributes) ->
    attributes.index = @index
    $(@el).html(@template(attributes))
    @render_datepicker()

  render_datepicker: () ->
    el = @el
    $(el).find('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker').datepicker('hide')
      $(el).find('.datepicker').blur()
    )

  remove_expression: () ->
    $(@el).find("._destroy").val(1)
    @segment_form.remove_expression(this)

  select_attribute: (ev) ->
    attributes = _.clone(@model.attributes)
    attributes.value_type = $(ev.currentTarget).find('option:selected').attr('value_type')
    attributes.name = $(ev.currentTarget).find('option:selected').attr('value')
    attributes.operator = $(@el).find('.operator-select option:selected').attr('value')
    @redraw(attributes)

  select_operator: (ev) ->
    attributes = _.clone(@model.attributes)
    attributes.operator = $(ev.currentTarget).find('option:selected').attr('value')
    attributes.value_type = $(@el).find('.attributes-select option:selected').attr('value_type')
    attributes.name = $(@el).find('.attributes-select option:selected').attr('value')
    @redraw(attributes)