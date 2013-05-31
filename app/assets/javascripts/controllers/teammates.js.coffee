#= require ../lib/teammate_editor
#= require ../lib/modal_editor_controller
#= require ../lib/wiselinks_manager

controller = null

@App.initTeammates = (options) ->
  App.WiselinksManager.setup()
  controller = new TeammatesController(options)
  controller.run()

class TeammatesController extends App.ModalEditorController
  newButtonSelector: "#new-teammate-button"

  postConstructor: ->
    @editor = new App.TeammateEditor("#new-teammate-editor")

  run: ->
    super()
    @labelTimeTags()

  labelTimeTags: ->
    $('time').each ->
      time = $(this)
      time.text moment(time.attr("datetime")).fromNow()
