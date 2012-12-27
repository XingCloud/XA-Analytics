class Analytics.Routers.TranslationsRouter extends Backbone.Router
  routes:
    "translations": "index"

  initialize: () ->

  index: () ->
    if Instances.Collections.translations.view?
      Instances.Collections.translations.view.redraw()
    else
      Instances.Collections.translations.view = new Analytics.Views.Translations.IndexView({
        collection: Instances.Collections.translations
      })
      Instances.Collections.translations.view.render()
    $('#main-container').html(Instances.Collections.translations.view.el)