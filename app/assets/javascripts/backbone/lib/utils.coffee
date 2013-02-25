Analytics.Utils ||= {}
Analytics.Utils.parseUTCDate = (date_str, offset) ->
  new Date(moment(date_str + " +0000", "YYYY-MM-DD HH:mm Z").unix()*1000 + offset).getTime()

Analytics.Utils.formatUTCDate = (timestamp, format) ->
  timezone_offset = (new Date().getTimezoneOffset() + 480)*60000
  moment(timestamp + timezone_offset).format(if format? then format else "YYYY/MM/DD")

Analytics.Utils.formatLabelDate = (timestamp, format) ->
  moment(timestamp + new Date().getTimezoneOffset() * 60000).format(if format? then format else "YYYY/MM/DD")

Analytics.Utils.pickUTCDate = (timestamp) ->
  timestamp - (new Date().getTimezoneOffset() + 480)*60000

Analytics.Utils.pickUTCStart = (timestamp = null) ->
  if not timestamp?
    timestamp = new Date().getTime()
  timestamp - timestamp % 86400000 - 28800000

Analytics.Utils.countMonth = (end, start) ->
  start_date = new Date(start)
  end_date = new Date(end)
  (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth() + 1

Analytics.Utils.intervalName = (interval) ->
  item = _.find(Analytics.Static.report_tab_intervals(), (item) -> item.value == interval)
  if item?
    item.name
  else
    ""

Analytics.Utils.intervalCount = (end_time, interval, day_count) ->
    period = day_count * 86400000
    switch interval
      when "min5" then period / 300000
      when "hour" then period / 3600000
      when "day"  then period / 86400000
      when "week" then (if period < 604800000 then 1 else Math.ceil(period / 604800000))
      when "month" then Analytics.Utils.countMonth(end_time, end_time - period)
      else 0

Analytics.Utils.getColor = (index, compare) ->
  colors = [['058DC7', 'AADFF3'], ['ED7E17','F2D5BD'], ['50B432','C9E7BE'], ['AF49C5','E1C9E8'], ['EDEF00','F6F3B1'], ['8080FF','DADBFB'], ['A0A424','E7E6B4'], ['E3071C','F4B3BC'],['663300', 'E0D6CC'],['0033CC','99ADEB'],['006600','99C299'],['FF66FF','FFD1FF'],['00B28F','B2E8DD'],['997A99','E0D7E0'],['6B6B47','C0C0BE'],['993D5C','E0C5CE']]
  if index >= colors.length
    Math.floor(Math.random()*16777215).toString(16).toUpperCase()
  else
    (if compare then colors[index][1] else colors[index][0])

# 检查输入的日期是否合法。
# 日期有效性：
# * 未来时间不能选。
# 总数限制：
# * 点的个数不能太多：最多1440个点。
# * 总日期不能太长：最多365天。
# 及时性限制：
# * 如果是按天选择的报告，那么今天不能被包括在内。

Analytics.Utils.validateDateRange = (end_time, length, interval) ->
  now = new Date()
  if(now.getTime() < end_time)
    return ret =
      result: false
      message: "err_future"
  if length > 365
    return ret =
      result: false
      message: "err_days"
  periods = Analytics.Utils.intervalCount(end_time, interval, length)
  if(periods > 2016) # 288*7, 7天的每5分钟数据
    return ret =
      result: false
      message: "err_points"

  if((interval == "day") && new Date(now.getFullYear(), now.getMonth(), now.getDate()) <= end_time)
    return ret =
      result: false
      message: "err_today"

  ret =
    result: true


Analytics.Utils.checkReportTabRange = (length, interval) ->
  same_lengths = _.filter(Analytics.Static.report_tab_ranges(), (item) -> item.length == length)
  if same_lengths.length == 0
    null
  else if same_lengths.length == 1
    same_lengths[0]
  else if same_lengths.length > 1
    same_interval = _.find(same_lengths, (item) -> item.interval == interval)
    (if same_interval? then same_interval else same_lengths[1])

Analytics.Utils.checkFormFields = (form) ->
  valid = true
  for group in $(form).find('.control-group.should-check')
    $(group).removeClass('error')
    $(group).find('.controls .help-inline').remove()
    input = $(group).find('.controls input[type="text"]')
    value = input.val()
    if (input.hasClass('should-check-empty') and
        (not value? or value == ""))
      valid = false
      $(group).addClass('error')
      $(group).find('.controls').append('<span class="help-inline">'+ I18n.t("lib.utils.not_empty") + '</span>')
      continue

    if (value? and
        value != "" and
        input.hasClass('should-check-pattern') and
        not new RegExp(input.attr("pattern")).test(value))
      valid = false
      $(group).addClass('error')
      continue

    if (value? and
        value != "" and
        input.hasClass('should-check-integer') and
        isNaN(parseInt(value)))
      valid = false
      $(group).addClass('error')
      $(group).find('.controls').append('<span class="help-inline">'+ I18n.t("lib.utils.should_be_integer") + '</span>')
      continue

    if (value? and
        value != "" and
        input.hasClass('should-check-float') and
        isNaN(parseFloat(value)))
      valid = false
      $(group).addClass('error')
      $(group).find('.controls').append('<span class="help-inline">'+ I18n.t("lib.utils.should_be_number") + '</span>')
      continue

    if (value? and
        value != "" and
        input.hasClass('should-check-natural-number') and
        (isNaN(parseInt(value)) or parseInt(value) < 0))
      valid = false
      $(group).addClass('error')
      $(group).find('.controls').append('<span class="help-inline">'+ I18n.t("lib.utils.should_be_natural_number") + '</span>')
      continue

  valid

Analytics.Utils.timeShard = (time) ->
  if time < 100
    "0s-0.1s"
  else if time >= 100 and time < 200
    "0.1s-0.2s"
  else if time >= 200 and time < 500
    "0.2s-0.5s"
  else if time >= 500 and time < 1000
    "0.5s-1s"
  else if time >= 1000 and time < 2000
    "1s-2s"
  else if time >= 2000 and time < 5000
    "2s-5s"
  else if time >= 5000 and time < 10000
    "5s-10s"
  else if time >= 10000 and time < 30000
    "10s-30s"
  else if time >= 30000 and time < 60000
    "30s-60s"
  else
    "gte_1min"

Analytics.Utils.actionFinished = () ->
  if window.history.length > 0
    window.history.back()
  else
    if Analytics.Models.project?
      Analytics.Utils.redirect("dashboard")
    else
      Analytics.Utils.redirect("reports")

Analytics.Utils.zeroPad = (num, places) ->
  zero = places - num.toString().length + 1
  Array(+(zero > 0 && zero)).join("0") + num

Analytics.Utils.formatCSVOutput = (csv) ->
    ret = csv.replace(new RegExp("^[ \t]*\r?\n","gm"),"") #remove the empty line
    ret = ret.replace(new RegExp(",\"[ \r\n]*","gm"),",\"") #remove space after ,"
    ret = ret.replace(new RegExp("[ \r\n]*\",","gm"),"\",") #remove space before ", 
    ret = ret.replace(new RegExp("[ \r\n]*\"\r?\n","gm"),"\"\r\n") #remove space before "
    ret = ret.replace(new RegExp("&nbsp;","gm"),"")
    # ret = ret.replace(new RegExp("[\r\n]*\"[ \r\n]*","gm"),"\"") #remove space after "
    "\ufeff"+ret                #add utf-8 bom

Analytics.Utils.checkPushState = () ->
  window.history.pushState?

Analytics.Utils.hrefWrapper = (href) ->
  if Analytics.Utils.checkPushState()
    window.ROOT + '/' + href
  else
    '#' + href

Analytics.Utils.redirect = (href) ->
  if Analytics.Utils.checkPushState()
    Backbone.history.navigate(href, {trigger: true})
  else
    location.href = '#' + href