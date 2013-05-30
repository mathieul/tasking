#= require ../lib/story_editor
#= require ../lib/modal_editor_controller

controller = null

@App.initStories = (options) ->
  window.wiselinks ?= new Wiselinks($('body'), html4: false)
  controller = new StoriesController(options)
  controller.run()

class StoriesController extends App.ModalEditorController
  newButtonSelector: ".new-story-button"

  run: ->
    super()
    @makeStoriesStortable()
    @highlight()

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
          prevPosition = ui.item.prev().data("position")
          newPosition = if prevPosition? then prevPosition + 1 else  0
          ui.item.find("form")
            .find("input[name=position]")
              .val(newPosition)
              .end()
            .submit()

  highlight: ->
    for id in (@options.effects?["highlight"] || [])
      $("##{id}").effect(effect: "highlight", duration: 2000)
