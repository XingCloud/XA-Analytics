Analytics.Views.ProjectUsers ||= {}

class Analytics.Views.ProjectUsers.IndexView extends Backbone.View
  template: JST["backbone/templates/project_users/index"]

  events:
    "click a.btn.edit-project-user" : "edit"
    
  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "change", @redraw
    # 过滤掉已经被删除的report(todo:可以在服务器端完成)
    for model in @collection.models
      model.get("privilege").report_ids = _.filter(model.get("privilege").report_ids, (report_id) -> Instances.Collections.reports.get(report_id))

  redraw: ()->
    @render()
    @delegateEvents(@events)

  render: () ->
    $(@el).html(@template({project_users:@collection.models}))
    $(@el).find(".show-more").popover({
      html:false
      trigger:"click"
    })
    this

  edit: (ev)->
    id = $(ev.currentTarget).attr("value")
    model = @collection.get(id)
    new Analytics.Views.ProjectUsers.FormView({model:model}).render()
    