Analytics.Views.Expressions ||= {}

class Analytics.Views.Expressions.FormView extends Backbone.View
  template: JST['backbone/templates/expressions/expression_form']
  className: "expression"

  events:
    "click span#expression-remove" : "remove_expression"
    "change select.attributes-select" : "select_attribute"
    "change select.operator-select" : "select_operator"
    "click button.type-btn" : "change_time_type"

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
    $(@el).find('.btn-group').button()

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
    @redraw(@collect_attributes())

  select_operator: (ev) ->
    @redraw(@collect_attributes())

  change_time_type:(ev) ->
    $(@el).find('button.type-btn').removeClass('active')
    $(ev.currentTarget).addClass('active')
    $(@el).find("#time-type").val($(ev.currentTarget).attr("value"))
    @redraw(@collect_attributes())

  collect_attributes:() ->
    attributes = _.clone(@model.attributes)
    attributes.value_type = $(@el).find('.attributes-select option:selected').attr('value_type')
    attributes.name = $(@el).find('.attributes-select option:selected').attr('value')
    attributes.operator = $(@el).find('.operator-select option:selected').attr('value')
    attributes.time_type = $(@el).find(".btn-group button.active").attr('value') || "absolute"# absoulte time or relative time

    attributes
