#= require ../lib/story_editor

controller = null

@App.initStories = (options) ->
  controller = new StoriesController(options)

class StoriesController
  constructor: (@options = {}) ->
    @editor = new App.StoryEditor("#new-story-editor")
    @options.newStoryAttributes ?= {}
    @setupBehaviors()
    @showNowIfPresent()

  setupBehaviors: ->
    @setupNewStoryButton()
    @setupEditStoryButtons()

  setupNewStoryButton: ->
    $("#new-story-button").click (event) =>
      event.preventDefault()
      @editor.newResource(@newStory())

  setupEditStoryButtons: ->
    $("table.hidden-commands .command").on "click", "a", (event) =>
      event.preventDefault()
      target = $(event.currentTarget)
      action = target.data("action")
      data = target.closest(".command").data()
      @executeAction(action, data)

  executeAction: (action, data) ->
    switch action
      when "edit"
        @editor.editResource(data.content)
      when "insert-above"
        position = @newStory(row_order_position: data.position)
        @editor.newResource(position)
      when "insert-below"
        position = @newStory(row_order_position: data.position + 1)
        @editor.newResource(position)
      when "delete"
        alert "delete story is not yet implemented."

  showNowIfPresent: ->
    $("#show-now").modal("show")

  newStory: (updates = {}) ->
    $.extend({}, @options.newStoryAttributes, updates)
