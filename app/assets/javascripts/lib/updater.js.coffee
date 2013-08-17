#
# Updater: register to pubsub server through a websocket and update the page
#          accordingly.
#
# Steps to implement:
#   * update js controller to call #registerToUpdates in #setup (with controller instance as parameter)
#   * update js controller to call #unregisterFromUpdates in #destroy
#   * add a route collection GET refresh route
#   * update ruby controller actions intended to listen to changes to call #register_to_pubsub!
#   * update ruby controller actions intended to publish changes to call #publish!
#   * update ruby controller with adding a refresh action with setup to render the main partial
#   * add a refresh view that renders the main partial

class Updater
  constructor: (@options) ->
    {@roomId, @sid, @controller, @updateSel, websocketUrl} = @options
    @setup("#{websocketUrl}?room_id=#{@roomId}")
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
