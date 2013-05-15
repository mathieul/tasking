#= require ../lib/story_editor

controller = null

@App.initStories = (options) ->
  controller = new StoriesController(options)

class StoriesController
  constructor: (@options = {}) ->
    @editor = new App.StoryEditor("#new-story-editor")
    @options.newStoryAttributes ?= {}
    @setupBehaviors()

  setupBehaviors: ->
    @setupNewStoryButton()
    @setupEditStoryButtons()

  setupNewStoryButton: ->
    $("#new-story-button").click (event) =>
      event.preventDefault()
      @editor.newResource(newStory)

  setupEditStoryButtons: ->
    $("table.hidden-commands .command").on "click", "a", (event) =>
      event.preventDefault()
      target = $(event.currentTarget)
      action = target.data("action")
      content = target.closest(".command").data("content")
      if action is "edit"
        @editor.editResource(content)
      else
        console.log "TODO: execute action #{action} on", content
