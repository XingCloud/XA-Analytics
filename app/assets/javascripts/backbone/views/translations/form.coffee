Analytics.Views.Translations ||= {}
class Analytics.Views.Translations.FormView extends Backbone.View
  template: JST["backbone/templates/translations/form"]
  className: "modal translation-form"
  events:
    "click a.translation-submit": "submit"

  initialize: () ->
    _.bindAll this, "render"

  render: () ->
    attributes = _.clone(@model.attributes)
    attributes.original_text = @model.original_text
    $(@el).html(@template(attributes))
    $(@el).modal()

  submit: () ->
    if Analytics.Utils.checkFormFields($(@el).find('form'))
      update = @model.id?
      el = @el
      @model.save($(@el).find('form').toJSON(), {
        wait: true
        success: (model, response, options) ->
          if not update
            Instances.Collections.translations.add(model)
          $(el).modal('hide')
        error: (model, xhr, options) ->
          $(el).modal("hide")
      })