#= require ../lib/base_controller

class TeammatesController extends App.BaseController
  setup: ->
    @registerToUpdates(App.teammates)
    @labelTimeTags()
    @showEditorIfPresent()
    @autoCloseAlerts()
    @transitionWhenClosingModals()

  destroy: ->
    @unregisterFromUpdates()

@App.teammates = new TeammatesController
