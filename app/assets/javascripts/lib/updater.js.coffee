WS_URL = "ws://localhost:4000/web-socket"

class Updater
  constructor: (room_id) ->
    @onmessage = ->
    @setup("#{WS_URL}?room_id=#{room_id}")

  setup: (url) ->
    @ws = new WebSocket(url)
    @ws.onopen    = -> console.log ">>> connected"
    @ws.onmessage = (evt) => @onmessage JSON.parse(evt.data)
    @ws.onclose   = -> console.log ">>> connection closed"

  onUpdate: (@onmessage) ->

  destroy: ->
    @ws.close()

@App.Updater = Updater
