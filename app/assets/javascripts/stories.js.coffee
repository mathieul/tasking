@App ||= {}
@App.stories = {}

@App.stories.init = ->
  $("#new-story-button").click (event) ->
    event.preventDefault()
    $("#edit-story-modal").modal("show")