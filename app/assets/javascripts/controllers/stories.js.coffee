#= require ../lib/story_editor
#= require ../lib/modal_editor_controller

controller = null

@App.initStories = (options) ->
  controller = new StoriesController(options)
  controller.run()

class StoriesController extends App.ModalEditorController
  newButtonSelector: ".new-story-button"

  run: ->
    super()
    @makeStoriesStortable()

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

  makeStoriesStortable: ->
    $("#stories")
      .disableSelection()
      .sortable
        items:        "> tr.story-row"
        axis:         "y"
        placeholder: "story-placeholder"
        helper: (event, element) ->
          [width, height] = [element.outerWidth(), element.outerHeight()]
          $("<div/>")
            .text(element.find("td:nth(4)").text())
            .addClass("story-helper")
            .css(width: width, height: height, lineHeight: "#{height}px")
        stop: (event, ui) ->
          newPosition = ui.item.prev().data("position") or 0
          id = ui.item.data("id")
          alert "New position #{newPosition} for id #{id}."
