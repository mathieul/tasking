#= require ../lib/base_controller

class TeammatesController extends App.BaseController
  setup: ->
    @labelTimeTags()
    @showEditorIfPresent()
    @autoCloseAlerts()
    @transitionWhenClosingModals()

@App.teammates = new TeammatesController
