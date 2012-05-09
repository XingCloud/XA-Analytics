Analytics.Views.Dimensions ||= {}

class Analytics.Views.Dimensions.ShowView extends Backbone.View
  template: JST['backbone/templates/dimensions/show']
  className: 'dimensions'
  events:
    "click .dimensions-table th" : "sort_dimensions"
    "click .next-page.active" : "next_page"
    "click .previous-page.active" : "previous_page"
    "click button.jump-page" : "jump_page"
    "click a.dimension-value" : "filter_dimension"
    "click a.choose-primary-dimension" : "choose_dimension"
    "click a.add-dimension" : "add_dimension"
    "change select.pagesize" : "change_pagesize"

  initialize: (options) ->
    _.bindAll(this, "render")
    @model.bind "change", @render
    @report_tab_view = options.report_tab_view

  render: () ->
    $(@el).html(@template(@model.attributes))
    this

  fetch: () ->
    el = @el
    model = @model
    $(el).block({message: "<img src='/assets/dimensions-loading.gif'/>"})
    @model.fetch_data({
      success: (resp) ->
        model.set(resp.data)
        $(el).unblock()
      error: (resp) ->
        $(el).unblock()
    })

  next_page: (ev) ->
    page_num = Math.ceil(@model.get("total") / @model.get("pagesize"))
    if @model.get("index") + 1 < page_num
      @model.set({index: @model.get("index") + 1}, {silent: true})
      @fetch()

  previous_page: (ev) ->
    if @model.get("index") > 0
      @model.set({index: @model.get("index") - 1}, {silent: true})
      @fetch()

  jump_page: (ev) ->
    if @model.get("dimension")?
      index = parseInt($(@el).find("#page-index").val())
      page_num = Math.ceil(@model.get("total") / @model.get("pagesize"))
      if index > 0 and index <= page_num
        @model.set({index: index - 1}, {silent: true})
        @fetch()

  change_pagesize: (ev) ->
    if @model.get("dimension")?
      pagesize = parseInt($(@el).find('select.pagesize :selected').val())
      if pagesize != @model.get("pagesize")
        @model.set({index: 0, pagesize: pagesize}, {silent: true})
        @fetch()

  filter_dimension: (ev) ->
    value = $(ev.currentTarget).attr("value")
    dimension = @model.get("dimension")
    filter = {
      type: dimension.dimension_type
      name: dimension.name
      key: dimension.value
      value: value
    }
    oldfilter =  _.find(@model.get("filters"), (item) ->
      item.type == filter.type and item.key == filter.key
    )
    if not oldfilter?
      @model.get("filters").push(filter)
    level = @model.get("dimension").level
    @model.set({
      dimension: _.find(@model.get("dimensions"), (item) -> item.level == level+1)
    },{silent: true})
    @report_tab_view.redraw()

  sort_dimensions: (ev) ->
    if @model.get("dimension")?
      orderby = $(ev.currentTarget).attr("value")
      orderby = (if not orderby? then null else orderby)
      if orderby == @model.get("orderby")
        order = (if @model.get("order").toUpperCase() == 'DESC' then 'ASC' else 'DESC')
      else
        order = 'DESC'
      @model.set({
        orderby: orderby
        order: order
        index: 0
      }, {silent: true})
      @fetch()

  add_dimension: (ev) ->
    new_dimension = {
      name: $(@el).find('select.new-dimension option:selected').attr("name")
      value: $(@el).find('select.new-dimension option:selected').attr("value")
      dimension_type: $(@el).find('select.new-dimension option:selected').attr("dimension_type")
      level: @model.get("dimensions").length
      report_tab_id: @report_tab_view.model.id
    }
    @model.get("dimensions").push(new_dimension)
    @model.set({dimension: new_dimension}, {silent: true})
    @fetch()

  choose_dimension: (ev) ->
    value = $(ev.currentTarget).attr("value")
    dimension_type = $(ev.currentTarget).attr("dimension_type")
    dimension = _.find(@model.get("dimensions"), (item) ->
      item.value == value and item.dimension_type == dimension_type
    )
    dimension_filter = _.find(@model.get("filters"), (item) ->
      item.key == value and item.type == dimension_type
    )
    if dimension_filter?
      dimension_filter_index = @model.get("filters").indexOf(dimension_filter)
      @model.get("filters").splice(dimension_filter_index, @model.get("filters").length - dimension_filter_index)
      @model.set({dimension: dimension},{silent: true})
      @report_tab_view.redraw()
    else
      @model.set({dimension: dimension},{silent: true})
      @fetch()
