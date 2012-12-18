class XA
  url: "//xa.xingcloud.com/v4/"
  actions: []
  updates: []
  sending: false

  init: (options) ->
    if not options? or not options.app?
      throw new Error("App is required.")
    @app = options.app
    @uid = options.uid || "random"

  setUid: (uid) ->
    @uid = uid

  action: () ->
    for argument in arguments
      @actions.push(argument)
    @asyncSend()

  update: () ->
    for argument in arguments
      @updates.push(argument)
    @asyncSend()

  asyncSend: () ->
    rest = @url + @app + '/' + @uid + '?'
    index = 0
    item = null
    @sending = true
    while (item = @updates.shift())
      strItem = 'update' + index + '=' + encodeURIComponent(item) + '&'
      if rest.length + strItem.length >= 1980
        @updates.unshift(item)
      else
        rest = rest + strItem
      index = index + 1
    index = 0
    while (item = @actions.shift())
      strItem = 'action' + index + '=' + encodeURIComponent(item) + '&'
      if rest.length + strItem.length >= 1980
        @actions.unshift(item)
      else
        rest = rest + strItem
      index = index + 1
    (new Image()).src = rest + 'img&_ts=' + new Date().getTime()
    if @updates.length + @actions.length > 0
      @asyncSend()
    @sending = false
window.XA = new XA()