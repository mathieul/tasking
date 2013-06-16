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
    @initTaskTable()

  initDatePickers: ->
    $(".date .input-append").datetimepicker(pickTime: false)

  initTaskTable: ->
    @taskTable = new App.TaskTable
      currentTeammateId: @options.currentTeammateId
      selectors:
        add:      ".add-task"
        edit:     ".edit-task"
        destroy:  ".destroy-task"
        input:    ".task-input"
        command:  ".task-command"
        content:  ".task-content"
        task:     "td.task"
        handle:   ".move-task"
        teammate: ".set-teammate"
        wrapper:  "#task-table-wrapper"
      forms:
        create:   "#create-task-form"
        update:   "#update-task-form"
        destroy:  "#destroy-task-form"
