Analytics.Views.MaintenancePlans ||= {}

class Analytics.Views.MaintenancePlans.IndexView extends Backbone.View
  template: JST["backbone/templates/maintenance_plans/index"]
  events:
    "click a#new-maintenance-plan": "new_maintenance_plan"
    "click a.edit-maintenance-plan": "edit_maintenance_plan"
    "click a.remove-maintenance-plan": "remove_maintenance_plan"
    "click .nav.nav-tabs li": "change_tab"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @collection.bind "all", @redraw
    @collection.active_table = "active"

  render: () ->
    $(@el).html(@template(@collection))
    @render_table()

  render_table: () ->
    now = new Date().getTime()
    active_plans = @collection.filter((model) -> now >= Date.parse(model.get("begin_at")) and now <= Date.parse(model.get("end_at")))
    nonactive_plans = @collection.filter((model) -> now < Date.parse(model.get("begin_at")) or now > Date.parse(model.get("end_at")))

    new Analytics.Views.MaintenancePlans.IndexTableView({
      collection: active_plans
      el: $(@el).find('#maintenance-plan-active')
    }).render()
    new Analytics.Views.MaintenancePlans.IndexTableView({
      collection: nonactive_plans
      el: $(@el).find('#maintenance-plan-nonactive')
    }).render()

  redraw: () ->
    @render()
    @delegateEvents(@events)

  new_maintenance_plan: () ->
    new Analytics.Views.MaintenancePlans.FormView({
      model: new Analytics.Models.MaintenancePlan()
    }).render()

  edit_maintenance_plan: (ev) ->
    id = $(ev.currentTarget).attr("value")
    new Analytics.Views.MaintenancePlans.FormView({
      model: Instances.Collections.maintenance_plans.get(id)
    }).render()

  remove_maintenance_plan: (ev) ->
    if confirm(I18n.t('commons.confirm_delete'))
      id = $(ev.currentTarget).attr("value")
      model = Instances.Collections.maintenance_plans.get(id)
      model.destroy({
        wait: true
      })

  change_tab: (ev) ->
    @collection.active_table = $(ev.currentTarget).attr("type")

class Analytics.Views.MaintenancePlans.IndexTableView extends Backbone.View
  template: JST["backbone/templates/maintenance_plans/index-table"]
  events:
    "click .pre.enabled": "pre_page"
    "click .nex.enabled": "next_page"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @page = 1
    @max_page = (if @collection.length == 0 then 1 else Math.ceil(@collection.length / 10))

  render: () ->
    $(@el).html(@template({
      models: @collection
      page: @page
      max_page: @max_page
    }))

  redraw: () ->
    @render()
    @delegateEvents(@events)

  pre_page: () ->
    @page = @page - 1
    @redraw()

  next_page: () ->
    @page = @page + 1
    @redraw()
