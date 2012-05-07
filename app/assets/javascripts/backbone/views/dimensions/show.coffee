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
    "click a.dimension-choose" : "choose_dimension"
    "change select.pagesize" : "change_pagesize"

  initialize: (options) ->
    _.bindAll(this, "render")
    @model.bind "change", @render

  render: () ->
    if @model.get("dimensions").length > 0
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
    index = parseInt($(@el).find("#page-index").val())
    page_num = Math.ceil(@model.get("total") / @model.get("pagesize"))
    if index > 0 and index <= page_num
      @model.set({index: index - 1}, {silent: true})
      @fetch()

  change_pagesize: (ev) ->
    pagesize = parseInt($(@el).find('select.pagesize :selected').val())
    if pagesize != @model.get("pagesize")
      @model.set({index: 0, pagesize: pagesize}, {silent: true})
      @fetch()

  filter_dimension: (ev) ->
    value = $(ev.currentTarget).attr("value")
    level = @model.get("filters").length
    dimension = @model.get("dimensions")[level]
    @model.get("filters").push({
      type: dimension.dimension_type
      name: dimension.name
      key: dimension.value
      value: value
    })
    @model.set({index: 0}, {silent: true})
    @fetch()

  choose_dimension: (ev) ->
    index = parseInt($(ev.currentTarget).attr("value"))
    level = @model.get("filters").length
    @model.get("filters").splice(index, level - index)
    @fetch()

  sort_dimensions: (ev) ->
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
