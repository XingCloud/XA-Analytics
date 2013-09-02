Analytics.Views.Ads ||= {}

class Analytics.Views.Ads.IndexView extends Backbone.View
  template: JST['backbone/templates/ads/index']
  events:
    "click #add-ad" : "add_ad"
    "click #remove-ad" : "remove_ad"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"

  initialize: () ->
    _.bindAll(this, "render", "redraw")
    @collection.bind "all", @redraw
    @page = 1
    @date = Analytics.Utils.formatUTCDate(new Date().getTime(), 'YYYY-MM-DD')

  redraw: () ->
    @render()
    @delegateEvents(@events)

  render: () ->
    @calc_page()
    $(@el).html(@template({
      ads: @models_to_show()
      date: @date # show all
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
    channel = @channel
    date = @date
    fee = @fee
    if @check_field()
      model = new Analytics.Models.Ad({date:@date, channel:@channel, fee:@fee})
      model.save({}, {wait:true, success: (model ,resp) ->
        collection.add(model)
        xa = new Analytics.XA()
        xa.init({app:Instances.Models.project.get("identifier"), uid:channel})
        xa.action("adcalc.cost,"+fee+","+Analytics.Utils.parseUTCDate(date, 0))
      })

  remove_ad:(ev) ->
    id = $(ev.currentTarget).attr("value")
    ad = @collection.get(id)
    if confirm(I18n.t('commons.confirm_delete'))
      ad.destroy({wait: true})

  check_field:() ->
    if not @channel? or @channel==""
      $("#add-ad-form span.error-message").html(I18n.t("templates.ads.channel")+" "+I18n.t("lib.utils.not_empty")+'!')
      return false

    if not( @fee? and new RegExp("^\\d+(\\.\\d+)?$").test(@fee))
      $("#add-ad-form span.error-message").html(I18n.t("templates.ads.fee")+" "+I18n.t("lib.utils.should_be_non_negative_number")+'!')
      return false

    $("#add-ad-form span.error-message").html("")
    true

  render_datepicker: () ->
    el = @el
    redraw = @redraw
    _this = @
    $(el).find('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker').datepicker('hide')
      $(el).find('.datepicker').blur()
      _this.date = $(el).find("#date").val()
      redraw()
    )

  models_to_show:()->
    _ret = @collection.models
    ret = _ret
    date = @date
    if @date? and @date != ""
      ret = _.filter(_ret, (x)-> x.get("date") == date)

    _.sortBy(ret,(x)-> x.get("created_at")).reverse()

  pre_page: (ev) ->
    @page = @page - 1
    @redraw()

  nex_page: (ev) ->
    @page = @page + 1
    @redraw()

  calc_page: () ->
    ret = @models_to_show()
    @max_page = (if ret.length == 0 then 1 else Math.ceil(ret.length / 10))
    if @page > @max_page
      @page = @max_page