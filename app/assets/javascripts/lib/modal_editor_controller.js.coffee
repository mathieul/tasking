class @App.ModalEditorController
  constructor: (@options = {}) ->
    @options.newAttributes ?= {}
    @postConstructor?()

  run: ->
    @setupBehaviors()
    @showNowIfPresent()

  setupBehaviors: ->
    @setupNewButtons(@newButtonSelector) if @newButtonSelector?
    @setupEditButtons()

  setupNewButtons: (selector) ->
    $(selector).click (event) =>
      event.preventDefault()
      @editor.newResource(@newResource())

  setupEditButtons: ->
    $("table.hidden-commands .command").on "click", "a", (event) =>
      event.preventDefault()
      target = $(event.currentTarget)
      action = target.data("action")
      data = target.closest(".command").data()
      @executeAction(action, data)

  executeAction: (action, data) ->
    @editor.editResource(data.content) if action is "edit"

  showNowIfPresent: ->
    $("#show-now").modal("show")

  newResource: (updates = {}) ->
    $.extend({}, @options.newAttributes, updates)
