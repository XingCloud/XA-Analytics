Analytics.Views.Dimensions ||= {}

class Analytics.Views.Dimensions.TagsView extends Backbone.View
  template: JST["backbone/templates/dimensions/tags"]
  events:
    "click .dimension-tag td.tag": "choose_dimension"
    "click .dimension-tag i.icon-remove-sign": "remove_dimension"
    "click .add-dimension-item": "add_dimension"
    "click .dimension-tag.filter": "click_filter"

  initialize: (options) ->
    _.bindAll this, "render"
    @parent_view = options.parent_view
    @report_tab_view = options.report_tab_view

  render: () ->
    $(@el).html(@template(@model.show_attributes()))
    $(@parent_view.el).find(".dimensions-panel").html(@el)

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  choose_dimension: (ev) ->
    dimension_value = $(ev.currentTarget).attr("dimension-value")
    dimension_type = $(ev.currentTarget).attr("dimension-type")
    dimension = _.find(@model.dimensions, (dimension) -> dimension.value == dimension_value and dimension.dimension_type == dimension_type)
    if dimension? and dimension != @model.dimension
      @do_choose_dimension(dimension)
      @redraw()
      @report_tab_view.dimensions_view.redraw({should_scroll: true})

  remove_dimension: (ev) ->
    dimension_value = $(ev.currentTarget).attr("dimension-value")
    dimension_type = $(ev.currentTarget).attr("dimension-type")
    dimension = _.find(@model.dimensions, (dimension) -> dimension.value == dimension_value and dimension.dimension_type == dimension_type)
    active = (dimension == @model.dimension)
    @model.dimensions.splice(@model.dimensions.indexOf(dimension), 1)
    if @model.dimensions.length > 0
      @model.dimension = @model.dimensions[0]
    else
      @model.dimension = null
    @redraw()
    if active
      @report_tab_view.dimensions_view.redraw({should_scroll: true})

  add_dimension: (ev) ->
    option = $(ev.currentTarget)
    @do_add_dimension(option.attr("value"), option.attr("dimension_type"), option.attr("value_type"))
    @redraw()
    @report_tab_view.dimensions_view.dimensions.activate()
    @report_tab_view.dimensions_view.redraw({should_scroll: true})

  click_filter: (ev) ->
    if $(ev.currentTarget).hasClass("all")
      @model.dimensions_filters().splice(0, @model.dimensions_filters().length)
      if @model.dimensions.length > 0
        @model.dimension = @model.dimensions[0]
      else
        @model.dimension = null
    else
      key = $(ev.currentTarget).attr("key")
      key_type = $(ev.currentTarget).attr("key_type")
      value_type = $(ev.currentTarget).attr("value_type")
      filter = _.find(@model.dimensions_filters(), (filter) -> filter.dimension.value == key and filter.dimension.dimension_type == key_type)
      filter_index = @model.dimensions_filters().indexOf(filter)
      @model.dimensions_filters().splice(filter_index, @model.dimensions_filters().length - filter_index)

      dimension = _.find(@model.dimensions, (dimension) -> dimension.value == key and dimension.dimension_type == key_type)
      if dimension?
        @do_choose_dimension(dimension)
      else
        @do_add_dimension(key, key_type, value_type)

    @report_tab_view.redraw()

  do_choose_dimension: (dimension) ->
    @model.dimension = dimension
    dimensions = [dimension]
    for old_dimension in @model.dimensions
      if old_dimension != dimension
        dimensions.push(old_dimension)
    @model.dimensions = dimensions

  do_add_dimension: (dimension_value, dimension_type, value_type) ->
    new_dimension = {
      name: Analytics.Static.getDimensionName(dimension_value)
      value: dimension_value
      dimension_type: dimension_type
      value_type: value_type
      report_tab_id: @model.id
    }
    @model.dimensions = [new_dimension].concat(@model.dimensions)
    @model.dimension = new_dimension