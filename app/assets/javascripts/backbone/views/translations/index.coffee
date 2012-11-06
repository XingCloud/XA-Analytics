Analytics.Views.Translations ||= {}
class Analytics.Views.Translations.IndexView extends Backbone.View
  template: JST["backbone/templates/translations/index"]
  events:
    "change select.resource": "change_resource"
    "change select.field": "change_field"
    "change select.language": "change_language"
    "change input.unfinished": "change_unfinished"
    "click li.pre.enabled": "previous_page"
    "click li.nex.enabled": "next_page"
    "click a.edit-translate": "edit_or_new"
    "click a.remove-translate": "remove"

  initialize: () ->
    _.bindAll this, "render", "redraw"
    @collection.bind "all", @redraw

  render: () ->
    $(@el).html(@template(@collection))
    if not @collection.synced
      @collection.sync_wrapper()

  redraw: () ->
    @render()
    @delegateEvents()

  change_resource: () ->
    value = $(@el).find("select.resource option:selected").attr("value")
    resource =_.find(@collection.resources, (resource) -> resource.value == value)
    @collection.resource = resource
    @collection.field = resource.fields[0]
    @collection.page = 1
    @redraw()

  change_field: () ->
    value = $(@el).find("select.field option:selected").attr("value")
    @collection.field = value
    @redraw()

  change_language: () ->
    value = $(@el).find("select.language option:selected").attr("value")
    @collection.language = value
    @redraw()

  previous_page: () ->
    @collection.page = @collection.page - 1
    @redraw()

  next_page: () ->
    @collection.page = @collection.page + 1
    @redraw()

  change_unfinished: () ->
    @collection.unfinished = $(@el).find("input.unfinished").is(":checked")
    @redraw()

  edit_or_new: (ev) ->
    resource_id = $(ev.currentTarget).attr("resource-id")
    resource = Instances.Collections[@collection.resource.collection].get(resource_id)
    translate = @collection.get_with_condition(resource.id)
    if not translate?
      translate = new Analytics.Models.Translation({
        rid: resource.id
        rtype: @collection.resource.value
        rfield: @collection.field
        locale: @collection.language
      })
    translate.original_text = resource.get(@collection.field)
    new Analytics.Views.Translations.FormView({
      model: translate
    }).render()

  remove: (ev) ->
    if (confirm("确认删除？"))
      resource_id = $(ev.currentTarget).attr("resource-id")
      resource = Instances.Collections[@collection.resource.collection].get(resource_id)
      translate = @collection.get_with_condition(resource.id)
      translate.destroy({
        wait: true
      })
