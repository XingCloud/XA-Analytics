class Analytics.Collections.Widgets extends Backbone.Collection
  model: Analytics.Models.Widget

  initialize: (models, options) ->
    @resource_name = "小窗口"
    @synced = false
    if options?
      @project = options.project
    now = new Date().getTime()
    @end_time = now - now % 86400000
    @columns = 3

  comparator: (lwidget, rwidget) ->
    if not lwidget.get("project_widget")? or not rwidget.get("project_widget")?
      true
    else if lwidget.get("project_widget").px == rwidget.get("project_widget").px
      lwidget.get("project_widget").py >= rwidget.get("project_widget").py
    else
      lwidget.get("project_widget").px >= rwidget.get("project_widget").px

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
      (widget.get("project_widget").px % columns == x and
      widget.get("project_widget").py?)
    )
    last_widget = _.last(widgets)
    (if last_widget? then last_widget.get("project_widget").py + 1 else 0)

  check_position: () ->
    project_widgets = []
    xcounter = 0
    ycounter = @positions()
    columns = @columns
    @each((widget) ->
      need_update = false
      project_widget = widget.get("project_widget")
      if not project_widget.px?
        project_widget.px = (xcounter % columns)
        xcounter = xcounter + 1
        need_update = true
      if not project_widget.py?
        project_widget.py = ycounter[project_widget.px]
        ycounter[project_widget.px] = ycounter[project_widget.px] + 1
        need_update = true
      if project_widget.px >= columns
        project_widget.px = (project_widget.px % columns)
        need_update = true
      if need_update
        project_widgets.push(project_widget)
    )
    if project_widgets.length > 0
      @update_project_widgets(project_widgets)

  update_project_widgets: (project_widgets) ->
    Analytics.Request.post({
      url: "/projects/" + @project.id + "/update_project_widgets"
      data: {project_widgets: JSON.stringify(project_widgets)}
    }, true)

  update_position: (widget_id, px, next_widget_id, prev_widget_ids) ->
    widget = @get(widget_id)
    py = (if next_widget_id? then @get(next_widget_id).get("project_widget").py + 1 else 0)
    if (widget.get("project_widget").px != px or
        widget.get("project_widget").py != py)
      widget.get("project_widget").px = px
      widget.get("project_widget").py = py
      project_widgets = [widget.get("project_widget")]
      for prev_widget_id in prev_widget_ids
        prev_widget = @get(prev_widget_id)
        prev_widget.get("project_widget").py = prev_widget.get("project_widget").py + 1
        project_widgets.push(prev_widget.get("project_widget"))
      @update_project_widgets(project_widgets)
