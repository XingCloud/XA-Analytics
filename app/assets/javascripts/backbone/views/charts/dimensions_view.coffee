Analytics.Views.Charts ||= {}

###
model: Analytics.Models.ReportTab
render_to: render_to
parent_view: Analytics.Views.ReportTabs.ShowView
###
class Analytics.Views.Charts.DimensionsView extends Backbone.View
  template: JST["backbone/templates/charts/dimension"]
  events:
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
    @report_tab_view = options.report_tab_view
    @report_tab = options.report_tab
    @dimensions =  options.collection  # we binding change in TableView

  render: (should_fetch = true, should_scroll = false) ->
    $(@el).html(@template(@report_tab.show_attributes()))
    @render_dimensions_chart()
    $(@render_to).html(@el)
    if should_scroll
      $('body').animate({
        scrollTop: $(@el).offset().top
      })
    if should_fetch
      @fetch_dimensions()

  render_dimensions_chart: () ->
    render_to = $(@el).find(".dimensions-chart")[0]
    @dimensions_chart_view = new Analytics.Views.Dimensions.TableView({  # reconstruct everytime cause we may have different dimensions
      collection: @dimensions
      render_to: render_to
    })
    @dimensions_chart_view.render()

  redraw: (options = {}) ->  # invoked after we change the dimensions on the panel or ...
    @remove()
    if options.render_to
      @render_to = options.render_to
    @dimensions.index = 0
    @dimensions.query = null
    @dimensions.total = 0
    should_fetch = (if options.should_fetch? then options.should_fetch else true)
    should_scroll = (if options.should_scroll? then options.should_scroll else false)
    @render(should_fetch, should_scroll)
    @delegateEvents(@events)

  fetch_dimensions: () ->
    if @report_tab.dimension?
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
    if @report_tab.dimension?
      index = parseInt($(@el).find("#page-index").val())
      page_num = Math.ceil(@dimensions.total / @dimensions.pagesize)
      if index > 0 and index <= page_num
        @dimensions.index = index - 1
        @fetch_dimensions()

  change_pagesize: (ev) ->
    if @report_tab.dimension?
      pagesize = parseInt($(@el).find('select.pagesize :selected').val())
      if pagesize != @dimensions.pagesize
        @dimensions.pagesize = pagesize
        @fetch_dimensions()

  sort_dimensions: (ev) ->
    if @report_tab.dimension?
      orderby = $(ev.currentTarget).attr("value")
      orderby = (if not orderby? then null else orderby)
      if orderby == @dimensions.orderby
        order = (if @dimensions.order.toUpperCase() == 'DESC' then 'ASC' else 'DESC')
      else
        order = 'DESC'
      @dimensions.order = order

      if @dimensions.orderby != orderby
        @dimensions.orderby = orderby
        @dimensions.orderby_change()

      @dimensions.index = 0
      @fetch_dimensions()

  choose_segment: (ev) ->
    segment_id = parseInt($(ev.currentTarget).attr("value"))
    @dimensions.segment_id = segment_id
    @fetch_dimensions()

  filter_dimension: (ev) ->
    XA.action("click.report.filter_dimension")
    value = $(ev.currentTarget).attr("value")
    filter = @report_tab.dimension.filter
    filter.value = value
    oldfilter =  _.find(@report_tab.dimensions_filters(), (item) ->
      item.dimension.dimension_type == filter.dimension.dimension_type and item.dimension.value == filter.dimension.value
    )
    if not oldfilter?
      @report_tab.dimensions_filters().push(filter)

    #update dimension, see report_tab#update_dimension

    @report_tab_view.redraw()

  change_gpattern: (ev) ->
    $(@el).find(".gpattern.modal").modal()

  submit_gpattern: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      form = $(@el).find('form').toJSON()
      name = @report_tab.dimension.value
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
    if $(@el).find(".blockOverlay").length > 0
      $(@el).unblock()

  download_table: (event) ->
    csv = $(@el).find(".dimensions-table table").table2CSV({delivery:'value'})
    event.currentTarget.href = 'data:text/csv;charset=UTF-8,'+encodeURIComponent(Analytics.Utils.formatCSVOutput(csv))
    