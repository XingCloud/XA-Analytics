Analytics.Views.Broadcastings ||= {}

###
collection: Instances.Collections.Broadcastings.first() # Broadcasting
###
class Analytics.Views.Broadcastings.IndexView extends Backbone.View
  template: JST['backbone/templates/broadcastings/index']
  events:
    "click .message-clear" : "clear_message"
    "click .broadcasting-preview" : "show_edit"
    "keydown .message-edit" : "check_submit"
    "blur .message-edit" : "submit_broadcasting"


  initialize: () ->
     @model.on("change", @redraw, this)

  render: () ->
    $(@el).html(@template(@model.attributes))
    $("#main-container").html($(@el))

  redraw: () ->
    @remove()
    @render()
    @delegateEvents(@events)

  clear_message: () ->
    $(@el).find(".message-edit").val("")
    @submit_broadcasting()

  show_edit: () ->
    $(@el).find(".message-content").hide()
    $(@el).find(".message-edit").show().focus()


  hide_edit: () ->
    $(@el).find(".message-content").show()
    $(@el).find(".message-edit").hide()

  check_submit: (event) ->
    if event.keyCode == 13
      $(@el).find(".message-edit").blur()


  submit_broadcasting: () ->
    @hide_edit()
    model = @model
    ##also triggers change event
    @model.save({message: $(@el).find(".message-edit").val()})
