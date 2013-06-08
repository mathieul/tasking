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
      currentTeammateId: @options.currentTeammateId
      selectors:
        add:      ".add-task"
        input:    ".task-input"
        command:  ".task-command"
        content:  ".task-content"
        wrapper:  "td.task"
      forms:
        create:   "#create-task-form"
        update:   "#update-task-form"
        destroy:  "#destroy-task-form"

  initDatePickers: ->
    $(".date .input-append").datetimepicker(pickTime: false)
