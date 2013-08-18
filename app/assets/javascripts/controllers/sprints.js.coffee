#= require ../lib/task_table
#= require ../lib/base_controller

class SprintsController extends App.BaseController
  setup: (options) ->
    @registerToUpdates(App.sprints)
    @initDatePickers()
    @initTaskTable()
    @initSprintTable()

  destroy: ->
    @unregisterFromUpdates()

  initDatePickers: ->
    $(".date .input-append").datetimepicker(pickTime: false)

  initTaskTable: ->
    @taskTable = new App.TaskTable
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

  initSprintTable: ->
    $("#sprints").on "click", "td:not(:first-child)", (event) ->
      event.preventDefault()
      $(event.target).closest("tr").find("td:first a").click()

@App.sprints = new SprintsController
