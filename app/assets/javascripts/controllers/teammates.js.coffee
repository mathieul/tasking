#= require ../lib/base_controller

class TeammatesController extends App.BaseController
  setup: ->
    @labelTimeTags()
    @showEditorIfPresent()
    @autoCloseAlerts()
    @transitionWhenClosingModals()
    @test()

  test: ->
    source = new EventSource("/messages/events")
    source.addEventListener "message", (event) ->
      console.log "event [#{event.event}]:", event.data

@App.teammates = new TeammatesController
