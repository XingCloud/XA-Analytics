class Analytics.Collections.Widgets extends Backbone.Collection
  model: Analytics.Models.Widget

  initialize: (options) ->
    @synced = false
    @project = options.project
    now = new Date().getTime()
    @end_time = now - now % 86400000
    @columns = 3

  comparator: (lwidget, rwidget) ->
    if not lwidget.get("widget_connector")? or not rwidget.get("widget_connector")?
      true
    else if lwidget.get("widget_connector").px == rwidget.get("widget_connector").px
      lwidget.get("widget_connector").py >= rwidget.get("widget_connector").py
    else
      lwidget.get("widget_connector").px >= rwidget.get("widget_connector").px

  url: () ->
    if @project?
      "/projects/"+@project.id+"/widgets"
    else
      "/template/widgets"

  sync_server: (options) ->
    collection = this
    if not @synced
      @fetch({
        success: (resp) ->
          collection.synced = true
          options.success(resp)
      })
    else
      options.success()

  positions: () ->
    positions = {}
    for i in [0..@columns-1]
      positions[i] = @position_y(i, @columns)
    positions

  position_y: (x) ->
    columns = @columns
    widgets = @filter((widget) ->
      (widget.get("widget_connector").px % columns == x and
      widget.get("widget_connector").py?)
    )
    last_widget = _.last(widgets)
    (if last_widget? then last_widget.get("widget_connector").py + 1 else 0)

  check_position: () ->
    widget_connectors = []
    xcounter = 0
    ycounter = @positions()
    columns = @columns
    @each((widget) ->
      need_update = false
      widget_connector = widget.get("widget_connector")
      if not widget_connector.px?
        widget_connector.px = (xcounter % columns)
        xcounter = xcounter + 1
        need_update = true
      if not widget_connector.py?
        widget_connector.py = ycounter[widget_connector.px]
        ycounter[widget_connector.px] = ycounter[widget_connector.px] + 1
        need_update = true
      if widget_connector.px >= columns
        widget_connector.px = (widget_connector.px % columns)
        need_update = true
      if need_update
        widget_connectors.push(widget_connector)
    )
    if widget_connectors.length > 0
      @update_widget_connectors(widget_connectors)

  update_widget_connectors: (widget_connectors) ->
    Analytics.Request.post({
      url: "/projects/" + @project.id + "/update_widget_connectors"
      data: {widget_connectors: JSON.stringify(widget_connectors)}
    }, true)

  update_position: (widget_id, px, next_widget_id, prev_widget_ids) ->
    widget = @get(widget_id)
    py = (if next_widget_id? then @get(next_widget_id).get("widget_connector").py + 1 else 0)
    if (widget.get("widget_connector").px != px or
        widget.get("widget_connector").py != py)
      widget.get("widget_connector").px = px
      widget.get("widget_connector").py = py
      widget_connectors = [widget.get("widget_connector")]
      for prev_widget_id in prev_widget_ids
        prev_widget = @get(prev_widget_id)
        prev_widget.get("widget_connector").py = prev_widget.get("widget_connector").py + 1
        widget_connectors.push(prev_widget.get("widget_connector"))
      @update_widget_connectors(widget_connectors)
