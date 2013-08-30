Analytics.Views.Ads ||= {}

class Analytics.Views.Ads.IndexView extends Backbone.View
  template: JST['backbone/templates/ads/index']
  events:
    "click #add_ad" : "add_ad"
    "click #remove_ad" : "remove_ad"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"

  initialize: () ->
    _.bindAll(this, "render", "redraw")
    @collection.bind "all", @redraw
    @page = 1

  redraw: () ->
    @render()
    @delegateEvents(@events)

  render: () ->
    @calc_page()
    $(@el).html(@template({
      ads: @collection.models
      page: @page
      max_page: @max_page
    }))
    @render_datepicker()
    this

  add_ad: () ->
    @date = $(@el).find("#date").val()
    @channel = $(@el).find("#channel").val()
    @fee = $(@el).find("#fee").val()

    collection = @collection
    if @check_field()
      model = new Analytics.Models.Ad({date:@date, channel:@channel, fee:@fee})
      model.save({}, {wait:true, success: (model ,resp) ->
        collection.add(model)
      })


  remove_ad:() ->
    id = $(ev.currentTarget).attr("value")
    ad = @collection.get(id)
    if confirm(I18n.t('commons.confirm_delete'))
      ad.destroy({wait: true})

  check_field:() ->

    true

  render_datepicker: () ->
    el = @el
    $(el).find('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker').datepicker('hide')
      $(el).find('.datepicker').blur()
    )

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    @collection
    @max_page = (if @collection.length == 0 then 1 else Math.ceil(@collection.length / 10))
    if @page > @max_page
      @page = @max_page