#= require ../lib/story_editor
#= require ../lib/modal_editor_controller

controller = null

@App.initStories = (options) ->
  controller = new StoriesController(options)
  controller.run()

class StoriesController extends App.ModalEditorController
  newButtonSelector: "#new-story-button"

  postConstructor: ->
    @editor = new App.StoryEditor("#new-story-editor")

  executeAction: (action, data) ->
    switch action
      when "edit"
        @editor.editResource(data.content)
      when "insert-above"
        position = @newResource(row_order_position: data.position)
        @editor.newResource(position)
      when "insert-below"
        position = @newResource(row_order_position: data.position + 1)
        @editor.newResource(position)
