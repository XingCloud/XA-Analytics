Analytics.Views.Dimensions ||= {}

class Analytics.Views.Dimensions.TagsView extends Backbone.View
  template: JST["backbone/templates/dimensions/dimension_tags"]
  events:
    "click .dimension-tag td.tag": "choose_dimension"
    "click .dimension-tag i.icon-remove-sign": "remove_dimension"
    "click .add-tag .tag": "add_dimension"
    "click li .dimension-value-item": "click_dimension_value_item"
    "keyup .dimension-value-search input" : "keyup_toggle"
    "keydown .dimension-value-search input" : "keydown_toggle"
    "mouseover .dimension-value-list .dimension-value-item" : "highlight_dimension_value"
    "click .dimension-value-search" : "click_search"
    "mouseenter .dropdown-toggle"  : "right2down"
    "mouseleave .dropdown-toggle"  : "down2right"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @parent_view = options.parent_view
    @report_tab_view = options.report_tab_view
    @dimensions_view = @report_tab_view.dimensions_view
    @report_tab_view.dimensions.on "change", @redraw # we need to update dimension dropdown while dimensionchart change

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
      @dimensions_view.redraw()

  remove_dimension: (ev) ->
    dimension_value = $(ev.currentTarget).attr("dimension-value")
    dimension_type = $(ev.currentTarget).attr("dimension-type")
    dimension = _.find(@model.dimensions, (dimension) -> dimension.value == dimension_value and dimension.dimension_type == dimension_type)
    @model.dimensions.splice(@model.dimensions.indexOf(dimension), 1)
    model_dimension = @model.dimension # following redraw may change the dimension, we need to backup for next step
    @redraw()
    if dimension_value == model_dimension.value and dimension_type == model_dimension.dimension_type
      @dimensions_view.redraw()

  add_dimension: (ev) ->
    option = $(ev.currentTarget)
    @do_add_dimension(option.attr("value"), option.attr("dimension_type"), option.attr("value_type"))
    @redraw()
    @dimensions_view.redraw()

  do_choose_dimension: (dimension) ->
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


  click_dimension_value_item: (ev)->
    dimension_filter_index = parseInt($(ev.currentTarget).attr("filter_index"))
    dimension_value = $(ev.currentTarget).attr("dimension_value")
    @change_dimension_value(dimension_filter_index, dimension_value)

  keyup_toggle: (ev) ->
    switch ev.keyCode
      when 40 then break
      when 38 then break
      when 13 then break
      else @filter_dimension_value(ev)

  keydown_toggle: (ev) ->
    switch ev.keyCode
      when 40 then @highlight_next_project()
      when 38 then @highlight_prev_project()
      when 13 then @confirm_search(ev)

  filter_dimension_value: (ev) ->
    current_dropdown = $(ev.currentTarget).parents("li.dropdown")
    current_dropdown.find(".dimension-value-list .dimension-value-no-match").addClass("hide")
    filter = current_dropdown.find(".dimension-value-search input").val()
    if filter? and filter.length > 0
      filter = filter.toLowerCase()
      no_data = true
      current_dropdown.find(".dimension-value-list .dimension-value-item").each((index, dimension_value_item) ->
        dimension_value = $(dimension_value_item).attr("dimension_value").toLowerCase()
        contains = dimension_value.indexOf(filter) != -1
        if contains
          no_data = false
        if not contains and not $(dimension_value_item).hasClass('hide')
          $(dimension_value_item).addClass("hide")
        else if contains and $(dimension_value_item).hasClass('hide')
          $(dimension_value_item).removeClass("hide")
      )
      if no_data
        current_dropdown.find(".dimension-value-list .dimension-value-no-match").removeClass("hide")
    else
      current_dropdown.find(".dimension-value-list .dimension-value-item").removeClass("hide")
    @highlight_first_dimension_value(current_dropdown)

  highlight_first_dimension_value: (current_dropdown) ->
    current_dropdown.find(".dimension-value-list .dimension-value-item").removeClass("selected")
    new_selected_dimension_value = current_dropdown.find(".dimension-value-list .dimension-value-item").not(".hide").first()
    if new_selected_dimension_value.length > 0
      @highligh_dimension_value_with_scroll(new_selected_dimension_value, current_dropdown)

  highligh_dimension_value_with_scroll: (dimension_value_item, current_dropdown) ->
    dimension_value_item.addClass("selected")
    maxHeight = parseInt($(current_dropdown).find(".dimension-value-list").css("height"), 10)
    visible_top = current_dropdown.find(".dimension-value-list").scrollTop()
    visible_bottom = maxHeight + visible_top
    high_top = dimension_value_item.position().top + visible_top
    high_bottom = high_top + dimension_value_item.outerHeight()
    if high_bottom >= visible_bottom
      current_dropdown.find(".dimension-value-list").scrollTop((if high_bottom > maxHeight then high_bottom - maxHeight else 0))
    else if high_top < visible_top
      current_dropdown.find(".dimension-value-list").scrollTop(high_top)

  highlight_dimension_value: (ev) ->
    current_dropdown = $(ev.currentTarget).parents("li.dropdown")
    current_dropdown.find(".dimension-value-list .dimension-value-item").removeClass("selected")
    $(ev.currentTarget).addClass("selected")


  confirm_search: (ev)->
    current_dropdown = $(ev.currentTarget).parents("li.dropdown")
    dimension_value = current_dropdown.find(".dimension-value-list .dimension-value-item.selected").attr("dimension_value")

    if dimension_value?
      dimension_filter_index = parseInt(current_dropdown.attr("filter_index"))
      @change_dimension_value(dimension_filter_index, dimension_value)

  change_dimension_value: (dimension_filter_index, dimension_value) ->
    # check if we are operating on the current dimension and select a specific dimension value, if so, put it to the filters.
    if dimension_filter_index == @model.dimensions_filters().length and dimension_value != "all-dimensions"
      new_dimension_filter = @model.dimension.filter
      new_dimension_filter.value =  dimension_value
      @model.dimensions_filters().push(new_dimension_filter)

    dimension_filter = @model.dimensions_filters()[dimension_filter_index]
    dimension_filter.value = dimension_value

    # splice the filters
    if dimension_value == "all-dimensions"
      @model.dimensions_filters().splice(dimension_filter_index , @model.dimensions_filters().length - dimension_filter_index + 1)
    else
      @model.dimensions_filters().splice(dimension_filter_index+1 , @model.dimensions_filters().length - dimension_filter_index + 1)

    #change dimension, see report_tab#update_dimension

    @report_tab_view.redraw()  # we need to redraw the whole report_tab not just dimension view

  right2down: (ev) ->
    $(ev.currentTarget).find("i.dropdown-toggle").removeClass("icon-chevron-right").addClass("icon-chevron-down")

  down2right: (ev) ->
    if not $(ev.currentTarget).hasClass("current-dimension")
      $(ev.currentTarget).find("i.dropdown-toggle").removeClass("icon-chevron-down").addClass("icon-chevron-right")