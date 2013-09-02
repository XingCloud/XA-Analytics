Analytics.Views.Ads ||= {}

class Analytics.Views.Ads.IndexView extends Backbone.View
  template: JST['backbone/templates/ads/index']
  events:
    "click #add-ad" : "add_ad"
    "click #remove-ad" : "remove_ad"
    "click td.td-fee label i" : "edit_fee"
    "mouseenter td.td-fee label" : "handle_mouseenter"
    "mouseleave td.td-fee label" : "handle_mouseleave"
    "blur td.td-fee input" : "update_fee"
    "keyup td.td-fee input" : "handle_keyup"
    "click #list-all" : "list_all"
    "click li.pre.enabled a" : "pre_page"
    "click li.nex.enabled a" : "nex_page"

  initialize: () ->
    _.bindAll(this, "render", "redraw")
    @collection.bind "all", @redraw
    @page = 1
    @date = Analytics.Utils.formatUTCDate(new Date().getTime(), 'YYYY-MM-DD')
    @list_all_ads = false

  redraw: () ->
    @render()
    @delegateEvents(@events)

  render: () ->
    @calc_page()
    $(@el).html(@template({
      ads: @models_to_show()
      date: @date
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
    _this = @
    if @check_field()
      model = new Analytics.Models.Ad({date:@date, channel:@channel, fee:@fee})
      model.save({}, {wait:true, success: (model ,resp) ->
        collection.add(model)
        _this.xa_log(date, channel, fee)
      })

  edit_fee: (ev) ->
    target = $(ev.currentTarget).parent().parent()
    target.find("input").css("display", "inline")
    target.find("input").focus()
    target.find("label").css("display", "none")
    target.find("span.error-message").html("")

  update_fee: (ev) ->
    id = $(ev.currentTarget).parent().attr("ad-id")
    model = @collection.get(id)
    fee = $(ev.currentTarget).val()
    redraw = @redraw
    _this = @
    if @check_fee(fee, $(ev.currentTarget).parent().find("span.error-message"))
      model.save({fee:fee},{wait:true, success:(model, resp)->
        _this.xa_log(model.get("date"), model.get("channel"), model.get("fee"))
        redraw()
      })

      $(ev.currentTarget).css("display", "none")
      $(ev.currentTarget).prev().css("display", "inline")

  remove_ad:(ev) ->
    id = $(ev.currentTarget).attr("value")
    ad = @collection.get(id)
    if confirm(I18n.t('commons.confirm_delete'))
      ad.destroy({wait: true})

  check_field:() ->
    if not @channel? or @channel==""
      $("#add-ad-form span.error-message").html(I18n.t("templates.ads.channel")+" "+I18n.t("lib.utils.not_empty")+'!')
      return false

    if not @check_fee(@fee, $("#add-ad-form span.error-message"))
      return false

    $("#add-ad-form span.error-message").html("")
    true

  check_fee:(fee, selector) ->
    if not( fee? and new RegExp("^\\d+(\\.\\d+)?$").test(fee))
      selector.html(I18n.t("templates.ads.fee")+" "+I18n.t("lib.utils.should_be_non_negative_number")+'!')
      return false
    true

  render_datepicker: () ->
    el = @el
    redraw = @redraw
    _this = @
    $(el).find('.datepicker').datepicker({format: 'yyyy-mm-dd'}).on('changeDate', (ev) ->
      $(el).find('.datepicker').datepicker('hide')
      $(el).find('.datepicker').blur()
      _this.date = $(el).find("#date").val()
      _this.list_all_ads = false
      redraw()
    )

  list_all: () ->
    @list_all_ads = true
    @redraw()

  handle_keyup: (ev)->
    switch ev.keyCode
      when 13 then @update_fee(ev)

  handle_mouseenter:(ev)->
    $(ev.currentTarget).find("i").css("display","inline")

  handle_mouseleave:(ev)->
    $(ev.currentTarget).find("i").css("display","none")

  models_to_show:()->
    _ret = @collection.models
    ret = _ret
    date = @date
    if @date? and @date != "" and not @list_all_ads
      ret = _.filter(_ret, (x)-> x.get("date") == date)

    _.sortBy(ret,(x)-> x.get("created_at")).reverse()

  xa_log:(date, channel, fee)->
    xa = new Analytics.XA()
    xa.init({app:Instances.Models.project.get("identifier"), uid:channel})
    xa.action("adcalc.cost,"+fee+","+Analytics.Utils.parseUTCDate(date, 0))

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