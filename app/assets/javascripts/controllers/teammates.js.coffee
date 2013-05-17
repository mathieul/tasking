#= require ../lib/teammate_editor
#= require ../lib/modal_editor_controller

controller = null

@App.initTeammates = (options) ->
  controller = new TeammatesController(options)

class TeammatesController extends App.ModalEditorController
  newButtonSelector: "#new-teammate-button"

  postConstructor: ->
    @editor = new App.TeammateEditor("#new-teammate-editor")
