#= require ../lib/wiselinks_manager

controller = null

@App.initSprints = (options) ->
  App.WiselinksManager.setup()
  controller = new SprintsController(options)
  controller.run()

class SprintsController
  constructor: (@options) ->

  run: ->
    @initDatePickers()
    @initTaskTable()

  initDatePickers: ->
    $(".date .input-append").datetimepicker(pickTime: false)

  initTaskTable: ->
    $("table.tasks")
    $(".add-task").click (event) ->
      task = $(event.target).closest("td.task")
      [width, height] = [task.innerWidth(), task.innerHeight()]
      task.find(".task-command").hide()
      task.find(".task-content").hide()
      task.find(".task-input")
        .show()
        .width(width - 4)
        .height(height - 6)
        .select()
    $(".task-input").blur (event) ->
      task = $(event.target).closest("td.task")
      input = task.find(".task-input").hide()
      task.find(".task-command").show()
      task.find(".task-content")
        .show()
        .text(input.val())
