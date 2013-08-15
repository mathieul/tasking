#= require ../lib/base_controller

class TeammatesController extends App.BaseController
  setup: ->
    @labelTimeTags()
    @showEditorIfPresent()
    @autoCloseAlerts()
    @transitionWhenClosingModals()
    @registerToUpdates(App.teammates)

  teardown: ->
    @unregisterFromUpdates()

@App.teammates = new TeammatesController
