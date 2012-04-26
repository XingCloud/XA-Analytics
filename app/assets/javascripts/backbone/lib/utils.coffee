Analytics.Utils ||= {}
Analytics.Utils.parseDate = (date_str) ->
  Date.parse(date_str.replace(/-/g, '/'))

Analytics.Utils.parseUTCDate = (date_str, offset) ->
  date = new Date(Date.parse(date_str.replace(/-/g, '/'))+offset)
  Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes())

Analytics.Utils.countMonth = (end, start) ->
  start_date = new Date(start)
  end_date = new Date(end)
  (end_date.getFullYear() - start_date.getFullYear()) * 12 + end_date.getMonth() - start_date.getMonth() + 1

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
