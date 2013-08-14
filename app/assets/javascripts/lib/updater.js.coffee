WS_URL = "ws://localhost:4000/web-socket"

class Updater
  constructor: (sid) ->
    console.log "sid = #{sid}"
    ws = new WebSocket("#{WS_URL}?sid=#{sid}")
    @onmessage = ->
    @setup(ws)

  setup: (ws) ->
    ws.onopen    = -> console.log ">>> connected"
    ws.onmessage = (evt) => @onmessage JSON.parse(evt.data)
    ws.onclose   = -> console.log ">>> connection closed"

  onUpdate: (@onmessage) ->

@App.Updater = Updater
