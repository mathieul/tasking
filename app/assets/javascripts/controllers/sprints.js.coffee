#= require ../lib/wiselinks_manager
#= require ../lib/task_table

controller = null

@App.initSprints = (options) ->
  App.WiselinksManager.setup()
  controller = new SprintsController(options)
  controller.run()

class SprintsController
  constructor: (@options) ->

  run: ->
    @initDatePickers()
    @taskTable = new App.TaskTable
      add:      ".add-task"
      input:    ".task-input"
      command:  ".task-command"
      content:  ".task-content"
      wrapper:  "td.task"
    @taskTable.setup()

  initDatePickers: ->
    $(".date .input-append").datetimepicker(pickTime: false)
