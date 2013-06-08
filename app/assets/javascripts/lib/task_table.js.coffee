class @App.TaskTable
  constructor: (options) ->
    @currentTeammateId = options.currentTeammateId
    @selectors = options.selectors
    @forms = {}
    @forms[kind] = $(selector) for kind, selector of options.forms
    @setup()

  setup: ->
    $(@selectors.add).on("click", this, handlers.addTask)
    $(@selectors.input).on("blur", this, handlers.newTask)

handlers =
  addTask: (event) ->
    {selectors} = event.data
    task = $(event.target).closest(selectors.wrapper)
    [width, height] = [task.innerWidth() - 4, task.innerHeight() - 6]
    task
      .find(selectors.command)
        .hide()
        .end()
      .find(selectors.content)
        .hide()
        .end()
      .find(selectors.input)
        .show()
        .width(width)
        .height(height)
        .select()

  newTask: (event) ->
    {forms, selectors, currentTeammateId} = event.data
    task = $(event.target).closest(selectors.wrapper)
    input = task.find(selectors.input)
    action = forms.create.data("create").replace(/__taskable_story_id__/, task.data("taskableStoryId"))
    forms.create
      .attr(action: action)
      .find("#task_row_order_position")
        .val("last")
        .end()
      .find("#task_description")
        .val(input.val())
        .end()
      .find("#task_hours")
        .val(0)
        .end()
      .find("#task_status")
        .val(task.data("status"))
        .end()
      .find("#task_teammate_id")
        .val(currentTeammateId)
        .end()
      .submit()
