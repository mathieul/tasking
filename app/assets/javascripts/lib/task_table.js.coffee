class @App.TaskTable
  constructor: (@selectors) ->

  setup: ->
    @setupAddButtons()
    @setupInputFields()

  setupAddButtons: ->
    $(@selectors.add).click (event) =>
      task = $(event.target).closest(@selectors.wrapper)
      [width, height] = [task.innerWidth() - 4, task.innerHeight() - 6]
      task.find(@selectors.command).hide()
      task.find(@selectors.content).hide()
      task.find(@selectors.input)
        .show()
        .width(width)
        .height(height)
        .select()

  setupInputFields: ->
    $(@selectors.input).blur (event) =>
      task = $(event.target).closest(@selectors.wrapper)
      input = task.find(@selectors.input).hide()
      task.find(@selectors.command).show()
      task.find(@selectors.content)
        .show()
        .text(input.val())
