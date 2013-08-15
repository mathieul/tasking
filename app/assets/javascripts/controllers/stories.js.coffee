#= require ../lib/base_controller
#= require ../lib/updater

class StoriesController extends App.BaseController
  setup: ->
    @showEditorIfPresent()
    @autoCloseAlerts()
    @transitionWhenClosingModals()
    @enablePointSelector()
    @makeStoriesSortable()
    @updateVelocityOnChange()
    @registerToUpdates($(document.body).data())

  teardown: ->
    @disablePointSelector()
    @unloadVelocityChange()
    @undoStoriesSortable()
    @unregisterFromUpdates()

  enablePointSelector: ->
    $("form .point-selector").on "click", ".btn", (event) ->
      target = $(event.currentTarget)
      target.closest(".controls").find("#story_points").val(target.data("value"))

  disablePointSelector: ->
    $("form .point-selector").off("click", ".btn")

  makeStoriesSortable: ->
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

  undoStoriesSortable: ->
    $("#stories")
      .sortable("destroy")
      .enableSelection()

  _newPositionFor: (item) ->
    newPosition = item.next(".story-row").data("position")
    return "last" unless newPosition?
    newPosition -=1 if newPosition > item.data("position")
    newPosition

  updateVelocityOnChange: ->
    $("#velocity").on "change", (event) ->
      $("#btn-new-sprint")
        .attr("disabled", true)
        .click (event) -> event.preventDefault()
      $(event.target).closest("form").submit()

  unloadVelocityChange: ->
    $("#velocity").off("change")

  registerToUpdates: (options) ->
    {roomId, sid} = options
    return unless roomId && sid
    @updater = new App.Updater(roomId)
    @updater.onUpdate (data) ->
      if data.from isnt sid
        url = "#{data.refresh_url}?#{(new Date).getTime()}"
        console.log "onUpdate(#{sid}): refresh[#{url}] using", data
        App.stories.teardown()
        $("#main").load url, ->
          if data.dom_id
            $("##{data.dom_id}").effect("highlight", duration: 1000)
          App.stories.setup()

  unregisterFromUpdates: ->
    @updater.destroy()

@App.stories = new StoriesController
