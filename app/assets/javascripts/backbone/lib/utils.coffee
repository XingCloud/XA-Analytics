Analytics.Utils ||= {}
Analytics.Utils.parseDate = (date_str) ->
  Date.parse(date_str.replace(/-/g, '/'))

Analytics.Utils.parseUTCDate = (date_str) ->
  date = new Date(Date.parse(date_str.replace(/-/g, '/')))
  Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes())