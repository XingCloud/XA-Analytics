Analytics.Views.ProjectUsers ||= {}

class Analytics.Views.ProjectUsers.IndexView extends Backbone.View
  template: JST["backbone/templates/project_users/project_user_index"]

  events:
    "click a.btn.edit-project-user" : "edit"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"
    
  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "change", @redraw
    # 过滤掉已经被删除的report(todo:可以在服务器端完成)
    for model in @collection.models
      model.get("privilege").report_ids = _.filter(model.get("privilege").report_ids, (report_id) -> Instances.Collections.reports.get(report_id))
    @page = 1

  redraw: ()->
    @render()
    @delegateEvents(@events)

  render: () ->
    @calc_page()
    $(@el).html(@template({
      project_users: @collection.models
      page: @page
      max_page: @max_page
    }))
    $(@el).find(".show-more").popover({
      html:false
      trigger:"click"
    })
    this

  edit: (ev)->
    id = $(ev.currentTarget).attr("value")
    model = @collection.get(id)
    new Analytics.Views.ProjectUsers.FormView({model:model}).render()

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    @max_page = (if @collection.length == 0 then 1 else Math.ceil(@collection.length / 10))
    if @page > @max_page
      @page = @max_page