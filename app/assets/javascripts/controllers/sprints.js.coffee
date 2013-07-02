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
        task:
          cell:     "td.task"
          add:      ".add-task"
          edit:     ".edit-task"
          destroy:  ".destroy-task"
          progress: ".progress-task"
          complete: ".complete-task"
          input:    ".task-input"
          command:  ".task-command"
          content:  ".task-content"
          handle:   ".move-task"
          teammate: ".set-teammate"
          wrapper:  "#task-table-wrapper"
        story:
          cell:     "td.story"
          edit:     ".edit-story"
          input:    ".story-input"
          command:  ".story-command"
          content:  ".story-content"
      forms:
        edit:     "#task-form"
        command:  "#command-task-form"
