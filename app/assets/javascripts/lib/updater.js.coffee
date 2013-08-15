WS_URL = "ws://localhost:4000/web-socket"

class Updater
  constructor: (room_id) ->
    ws = new WebSocket("#{WS_URL}?room_id=#{room_id}")
    @onmessage = ->
    @setup(ws)

  setup: (ws) ->
    ws.onopen    = -> console.log ">>> connected"
    ws.onmessage = (evt) => @onmessage JSON.parse(evt.data)
    ws.onclose   = -> console.log ">>> connection closed"

  onUpdate: (@onmessage) ->

@App.Updater = Updater
