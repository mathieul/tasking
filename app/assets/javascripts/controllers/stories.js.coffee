#= require ../lib/base_controller

wsTest = ->
  ws = new WebSocket "ws://localhost:4000/web-socket"

  ws.onopen = ->
    console.log ">>> connected"

  ws.onmessage = (evt) ->
    console.log "  - message received: #{evt.data}"

  ws.onclose = ->
    console.log ">>> connection closed"

class StoriesController extends App.BaseController
  setup: ->
    @showEditorIfPresent()
    @autoCloseAlerts()
    @transitionWhenClosingModals()
    @enablePointSelector()
    @makeStoriesStortable()
    @updateVelocityOnChange()
    wsTest()

  enablePointSelector: ->
    $("form .point-selector").on "click", ".btn", (event) ->
      target = $(event.currentTarget)
      target.closest(".controls").find("#story_points").val(target.data("value"))

  makeStoriesStortable: ->
    $("#stories")
      .disableSelection()
      .sortable
        items: "> tr.story-row"
        axis: "y"
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
              .val(@_newPositionFor(ui.item))
              .end()
            .submit()

  _newPositionFor: (item) ->
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

@App.stories = new StoriesController
