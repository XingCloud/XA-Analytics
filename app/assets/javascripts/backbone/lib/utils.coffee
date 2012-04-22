Analytics.Utils ||= {}
Analytics.Utils.parseDate = (date_str) ->
  Date.parse(date_str.replace(/-/g, '/'))

Analytics.Utils.parseUTCDate = (date_str) ->
  date = new Date(Date.parse(date_str.replace(/-/g, '/')))
  Date.UTC(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes())

Analytics.Utils.generateColor = (number) ->
  colors = [['058DC7', 'AADFF3'], ['ED7E17','F2D5BD'], ['50B432','C9E7BE'], ['AF49C5','E1C9E8'], ['EDEF00','F6F3B1'], ['8080FF','DADBFB'], ['A0A424','E7E6B4'], ['E3071C','F4B3BC'],['663300', 'E0D6CC'],['0033CC','99ADEB'],['006600','99C299'],['FF66FF','FFD1FF'],['00B28F','B2E8DD'],['997A99','E0D7E0'],['6B6B47','C0C0BE'],['993D5C','E0C5CE']]
  colors.slice(0, number)