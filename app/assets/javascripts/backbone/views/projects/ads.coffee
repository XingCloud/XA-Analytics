Analytics.Views.Projects ||= {}

class Analytics.Views.Projects.AdsView extends Backbone.View
  template: JST["backbone/templates/projects/ads"]

  initialize: (options) ->
    _.bindAll this, "render"
    @ads_view = new Analytics.Views.Ads.IndexView({collection: Instances.Collections.ads})
    @active = options.active

  render:()->
    $(@el).html(@template({
      active: @active,
      appid: Instances.Models.project.get("identifier")
    }))

    $(@el).find('#ads').html(@ads_view.render().el)

    @