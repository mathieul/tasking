WS_URL = "ws://localhost:4000/web-socket"

class Updater
  constructor: (@options) ->
    {@roomId, @sid, @controller, @updateSel} = @options
    @setup("#{WS_URL}?room_id=#{@roomId}")

  setup: (url) ->
    @ws = new WebSocket(url)
    @ws.onopen    = -> console.log ">>> connected"
    @ws.onmessage = (evt) => @onMessage JSON.parse(evt.data)
    @ws.onclose   = -> console.log ">>> connection closed"

  onMessage: (data) ->
    if data.from isnt @sid
      url = "#{data.refresh_url}?#{(new Date).getTime()}"
      @controller.teardown()
      $(@updateSel).load url, =>
        if data.dom_id
          $("##{data.dom_id}").effect("highlight", duration: 1000)
        @controller.setup()

  destroy: ->
    @ws.close()

@App.Updater = Updater
