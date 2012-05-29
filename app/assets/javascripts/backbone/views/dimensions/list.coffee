Analytics.Views.Dimensions ||= {}

class Analytics.Views.Dimensions.ListView extends Backbone.View
  template: JST["backbone/templates/dimensions/list"]
  events:
    "click .select-dimension" : "select_dimension"
    "click .add-dimension ul li a" : "add_dimension"
    "click button.search-dimension": "search_dimension"
    "click .dimensions-table th" : "sort_dimensions"
    "click .next-page.active" : "next_page"
    "click .previous-page.active" : "previous_page"
    "click button.jump-page" : "jump_page"
    "click a.dimension-value" : "filter_dimension"
    "click a.choose-segment" : "choose_segment"
    "change select.pagesize" : "change_pagesize"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @render_to = options.render_to
    @parent_view = options.parent_view
    @dimensions = new Analytics.Collections.DimensionCharts([], {
      selector: @model
      filters: @model.dimensions_filters
    })

  render: (should_fetch = true) ->
    $(@el).html(@template(@model.show_attributes()))
    @render_dimensions_chart()
    $(@render_to).html(@el)
    if should_fetch
      @fetch_dimensions()

  render_dimensions_chart: () ->
    render_to = $(@el).find(".dimensions-chart")[0]
    segment_ids = segments_router.segments.selected().concat(segments_router.templates.selected())
    @dimensions.initialize_charts(@model.get("metric_ids"), segment_ids)
    if not @dimensions_chart_view?
      @dimensions_chart_view = new Analytics.Views.Charts.DimensionsView({
        collection: @dimensions
        render_to: render_to
      })
      @dimensions_chart_view.render()
    else
      @dimensions_chart_view.redraw({render_to: render_to})

  redraw: (options = {}) ->
    @remove()
    if options.render_to
      @render_to = options.render_to
    @dimensions.index = 0
    @dimensions.query = null
    @dimensions.total = 0
    @render((if options.should_fetch? then options.should_fetch else true))
    @delegateEvents(@events)

  fetch_dimensions: () ->
    if @model.dimension?
      dimensions_chart_view = @dimensions_chart_view
      el = @el
      $(el).block({message: "<img src='/assets/dimensions-loading.gif'/>"})
      @dimensions.fetch_charts({
        success: (resp) ->
          dimensions_chart_view.redraw()
          $(el).unblock()
        error: (xhr, options, err) ->
          $(el).unblock()
      })

  select_dimension: (ev) ->
    value = $(ev.currentTarget).attr("value")
    dimension_type = $(ev.currentTarget).attr("dimension_type")
    @model.dimension = _.find(@model.dimensions, (item) ->
      item.value == value and item.dimension_type == dimension_type
    )
    @redraw()

  add_dimension: (ev) ->
    if @model.dimensions.length < 6
      option = $(ev.currentTarget)
      new_dimension = {
        name: option.attr("name")
        value: option.attr("value")
        dimension_type: option.attr("dimension_type")
        value_type: option.attr("value_type")
        level: @model.dimensions.length
        report_tab_id: @model.id
      }
      @model.dimensions.push(new_dimension)
      @model.dimension = new_dimension
      @redraw()
    else
      alert("最多支持六层细分")

  search_dimension: (ev) ->
    @dimensions.query = $(@el).find('input.search-dimension-query').val()
    @dimensions.index = 0
    @fetch_dimensions()

  next_page: (ev) ->
    page_num = Math.ceil(@dimensions.total / @dimensions.pagesize)
    if @dimensions.index + 1 < page_num
      @dimensions.index = @dimensions.index + 1
      @fetch_dimensions()

  previous_page: (ev) ->
    if @dimensions.index > 0
      @dimensions.index = @dimensions.index - 1
      @fetch_dimensions()

  jump_page: (ev) ->
    if @model.dimension?
      index = parseInt($(@el).find("#page-index").val())
      page_num = Math.ceil(@dimensions.total / @dimensions.pagesize)
      if index > 0 and index <= page_num
        @dimensions.index = index - 1
        @fetch_dimensions()

  change_pagesize: (ev) ->
    if @model.dimension?
      pagesize = parseInt($(@el).find('select.pagesize :selected').val())
      if pagesize != @dimensions.pagesize
        @dimensions.pagesize = pagesize
        @fetch_dimensions()

  sort_dimensions: (ev) ->
    if @model.dimension?
      orderby = $(ev.currentTarget).attr("value")
      orderby = (if not orderby? then null else orderby)
      if orderby == @dimensions.orderby
        order = (if @dimensions.order.toUpperCase() == 'DESC' then 'ASC' else 'DESC')
      else
        order = 'DESC'
      @dimensions.order = order
      @dimensions.orderby = orderby
      @dimensions.index = 0
      @fetch_dimensions()

  choose_segment: (ev) ->
    segment_id = parseInt($(ev.currentTarget).attr("value"))
    @dimensions.segment_id = segment_id
    @fetch_dimensions()

  filter_dimension: (ev) ->
    value = $(ev.currentTarget).attr("value")
    dimension = @model.dimension
    filter = {
      dimension: {
        dimension_type: dimension.dimension_type
        name: dimension.name
        value: dimension.value
        value_type: dimension.value_type
      }
      value: value
    }
    oldfilter =  _.find(@model.dimensions_filters, (item) ->
      item.dimension.dimension_type == filter.dimension.dimension_type and item.dimension.value == filter.dimension.value
    )
    if not oldfilter?
      @model.dimensions_filters.push(filter)
    level = @model.dimension.level
    @model.dimension =  _.find(@model.dimensions, (item) -> item.level == level + 1)
    @parent_view.redraw()