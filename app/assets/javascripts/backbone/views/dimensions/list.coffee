Analytics.Views.Dimensions ||= {}

###
model: Analytics.Models.ReportTab
render_to: render_to
parent_view: Analytics.Views.ReportTabs.ShowView
###
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
    "click a.change-gpattern" : "change_gpattern"
    "click a.submit-gpattern" : "submit_gpattern"
    "click a.download-table" : "download_table"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @render_to = options.render_to
    @parent_view = options.parent_view
    @dimensions = new Analytics.Collections.DimensionCharts([], {
      selector: @model
      filters: @model.dimensions_filters()
    })
    @dimensions.orderby = @model.get("metric_ids")[0] if @model.get("metric_ids")[0]?

  render: (should_fetch = true) ->
    $(@el).html(@template(@model.show_attributes()))
    @render_dimensions_chart()
    $(@render_to).html(@el)
    if should_fetch
      @fetch_dimensions()

  render_dimensions_chart: () ->
    render_to = $(@el).find(".dimensions-chart")[0]
    segment_ids = Instances.Collections.segments.selected()
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
      @dimensions.activate()
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
    XA.action("click.report.filter_dimension")
    value = $(ev.currentTarget).attr("value")
    dimension = @model.dimension
    filter = {
      dimension: {
        dimension_type: dimension.dimension_type
        name: Analytics.Static.getDimensionName(dimension.value)
        value: dimension.value
        value_type: dimension.value_type
      }
      value: value
    }
    oldfilter =  _.find(@model.dimensions_filters(), (item) ->
      item.dimension.dimension_type == filter.dimension.dimension_type and item.dimension.value == filter.dimension.value
    )
    if not oldfilter?
      @model.dimensions_filters().push(filter)
    level = @model.dimension.level
    @model.dimension =  _.find(@model.dimensions, (item) -> item.level == level + 1)
    @parent_view.redraw()

  change_gpattern: (ev) ->
    $(@el).find(".gpattern.modal").modal()

  submit_gpattern: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      form = $(@el).find('form').toJSON()
      name = @model.dimension.value
      user_attribute = _.find(Analytics.Static.getUserAttributes(), (item) -> item.name == name)
      if user_attribute.id?
        user_attribute = Instances.Collections.user_attributes.get(user_attribute.id)
      else
        user_attribute = new Analytics.Models.UserAttribute(user_attribute)
        user_attribute.set({project_id: Instances.Models.project.id})
      isnew = not user_attribute.id?
      view = this
      user_attribute.save(form, {wait:true, success: (model ,resp) ->
        $(view.el).find(".gpattern.modal").modal("hide")
        if isnew
          Instances.Collections.user_attributes.add(model, {silent: true})
        view.fetch_dimensions()
      })

  block: () ->
    $(@el).block({message: "<strong>" + I18n.t('commons.pending') + "</strong>"})

  unblock: () ->
    $(@el).unblock()

  download_table: (event) ->
    csv = $(@el).find(".dimensions-table table").table2CSV({delivery:'value'})
    event.currentTarget.href = 'data:text/csv;charset=UTF-8,'+encodeURIComponent(Analytics.Utils.formatCSVOutput(csv))
    