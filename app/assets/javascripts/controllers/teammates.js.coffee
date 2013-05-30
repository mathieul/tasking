#= require ../lib/teammate_editor
#= require ../lib/modal_editor_controller

controller = null

@App.initTeammates = (options) ->
  window.wiselinks ?= new Wiselinks($('body'), html4: false)
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
