#
# Updater: register to pubsub server through a websocket and update the page
#          accordingly.
#
# Steps to implement:
#   * 

# WS_URL = "ws://localhost:4000/web-socket"
WS_URL = "ws://wspubsub.cloudigisafe.com/web-socket"

class Updater
  constructor: (@options) ->
    {@roomId, @sid, @controller, @updateSel} = @options
    @setup("#{WS_URL}?room_id=#{@roomId}")
    @editing = false
    @buffered = null

  setup: (url) ->
    @ws = new WebSocket(url)
    @ws.onopen    = -> console.log ">>> connected"
    @ws.onmessage = (evt) => @onMessage JSON.parse(evt.data)
    @ws.onclose   = -> console.log ">>> connection closed"

  onMessage: (data) ->
    return if data.from is @sid
    if @editing
      @buffered = data
    else
      url = "#{data.refresh_url}?#{(new Date).getTime()}"
      @controller.destroy()
      $(@updateSel).load url, =>
        if data.dom_id
          $("##{data.dom_id}").effect("highlight", duration: 1000)
        @controller.setup()

  startEdit: ->
    console.log ">>> startEdit"
    @editing = true

  stopEdit: ->
    console.log ">>> stopEdit"
    @editing = false
    if @buffered
      console.log "stopEdit: unbuffer"
      @onMessage(@buffered)
      @buffered = null

  destroy: ->
    @ws.close()

@App.Updater = Updater
