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
        item:         "> tr.story-row"
        axis:         "y"
        placeholder: "ui-state-highlight"
        helper: (event, element) ->
          height = element.outerHeight()
          $("<div/>")
            .text(element.find("td:nth(4)").text())
            .css
              position: "absolute"
              width: element.outerWidth()
              height: "#{height}px"
              "line-height": "#{height}px"
              color: "blue"
              "text-align": "center"
              "font-weight": "bold"
              "background-color": "lightgray"
              "border-radius": "5px"
              "opacity": 0.6
              border: "2px darkgray solid"
