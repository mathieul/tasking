class TeammatesController
  setup: ->
    @labelTimeTags()
    @showEditorIfPresent()

  teardown: ->

  labelTimeTags: ->
    $('time').each ->
      time = $(this)
      time.text moment(time.attr("datetime")).fromNow()

  showEditorIfPresent: ->
    $("#editor").modal()

@App.teammates = new TeammatesController
