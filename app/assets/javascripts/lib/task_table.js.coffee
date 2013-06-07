class @App.TaskTable
  constructor: (options) ->
    @selectors = options.selectors
    @forms = {}
    @forms[kind] = $(selector) for kind, selector of options.forms
    @setup()

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
      input = task.find(@selectors.input)
      action = @forms.create.data("create").replace(/__taskable_story_id__/, task.data("taskableStoryId"))
      @forms.create
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
        .submit()
