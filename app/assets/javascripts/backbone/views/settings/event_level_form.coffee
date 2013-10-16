Analytics.Views.Settings ||= {}

class Analytics.Views.Settings.EventLevelsFormView extends Backbone.View
  template: JST["backbone/templates/settings/event-level-form"]
  events:
    "click a.btn.submit": "submit"

  initialize: (options) ->
    _.bindAll this, "render", "redraw"
    @model.view = this
    @model.bind "change", @redraw

  render: () ->
    $(@el).html(@template(@model.attributes))
    this

  redraw: () ->
    @render()
    @delegateEvents(@events)

  submit: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      form = $(@el).find('form').toJSON()
      @model.save(form, {wait: true, success: (model, resp) ->
        $('#success-message').remove()
        $('body').prepend(JST['backbone/templates/utils/success']())
        $('#success-message').fadeIn(500)
        $('#success-message').fadeOut(2000)
      })