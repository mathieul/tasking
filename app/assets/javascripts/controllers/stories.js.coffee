#= require ../lib/story_editor
#= require ../lib/modal_editor_controller

controller = null

@App.initStories = (options) ->
  controller = new StoriesController(options)
  controller.run()

class StoriesController extends App.ModalEditorController
  newButtonSelector: ".new-story-button"

  postConstructor: ->
    @editor = new App.StoryEditor("#new-story-editor")

  run: ->
    super()
    @makeStoriesStortable()
    @updateVelocityOnChange()
    @highlight()
    @autoCloseAlerts()

  autoCloseAlerts: ->
    alerts = $(".alert.auto-close")
    setTimeout (-> alerts.alert("close")), 5000

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
        stop: (event, ui) =>
          ui.item.find("form")
            .find("input[name=position]")
              .val(@newPositionFor(ui.item))
              .end()
            .submit()

  newPositionFor: (item) ->
    newPosition = item.next(".story-row").data("position")
    return "last" unless newPosition?
    newPosition -=1 if newPosition > item.data("position")
    newPosition

  updateVelocityOnChange: ->
    $("#velocity").change (event) ->
      $("#btn-new-sprint")
        .attr("disabled", true)
        .click (event) -> event.preventDefault()
      $(event.target).closest("form").submit()

  highlight: ->
    for id in (@options.effects?["highlight"] || [])
      $("##{id}").effect(effect: "highlight", duration: 2000)
