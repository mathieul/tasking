class @App.TaskTable
  constructor: (options) ->
    @currentTeammateId = options.currentTeammateId
    @selectors = options.selectors
    @forms = {}
    @forms[kind] = $(selector) for kind, selector of options.forms
    @setup()

  setup: ->
    $(@selectors.add).on("click", this, handlers.addTask)
    $(@selectors.input).on("keyup", this, handlers.cancelEditOnEscape)
    $(@selectors.teammate).on("click", this, handlers.selectTeammate)

  pushCurrentTask: (@currentTask) ->

  popCurrentTask: ->
    [task, @currentTask] = [@currentTask, null]
    task

  setTeammateIdForCurrentTask: (teammateId) ->
    @currentTask?.teammateId = teammateId

handlers =
  addTask: (event) ->
    {selectors} = event.data
    task = $(event.target).closest(selectors.wrapper)
    [width, height] = [task.innerWidth() - 4, task.innerHeight() - 6]
    task
      .find(selectors.command).hide().end()
      .find(selectors.content).hide().end()
      .find(selectors.input)
        .show()
        .width(width)
        .height(height)
        .select()
        .one("blur", event.data, handlers.createTask)

  selectTeammate: (event) ->
    teammateId = $(event.target).data("teammateId")
    event.data.setTeammateIdForCurrentTask(teammateId)

  createTask: (event) ->
    {forms, selectors, currentTeammateId} = table = event.data
    task = $(event.target).closest(selectors.wrapper)
    input = task.find(selectors.input)
    action = forms.create.data("create").replace(/__taskable_story_id__/, task.data("taskableStoryId"))
    table.pushCurrentTask
      action: action
      position: "last"
      description: input.val()
      hours: 0
      status: task.data("status")
      teammateId: currentTeammateId
    setTimeout (->
      task = table.popCurrentTask()
      forms.create
        .attr(action: task.action)
        .find("#task_row_order_position")
          .val(task.position)
          .end()
        .find("#task_description")
          .val(task.description)
          .end()
        .find("#task_hours")
          .val(task.hours)
          .end()
        .find("#task_status")
          .val(task.status)
          .end()
        .find("#task_teammate_id")
          .val(task.teammateId)
          .end()
        .submit()
    ), 250

  cancelEditOnEscape: (event) ->
    if event.keyCode is 27 # escape
      {selectors} = event.data
      task = $(event.target).closest(selectors.wrapper)
      task
        .find(selectors.command).show().end()
        .find(selectors.content).show().end()
        .find(selectors.input)
          .hide()
          .off("blur", handlers.createTask)
