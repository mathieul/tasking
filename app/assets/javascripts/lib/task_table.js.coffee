class @App.TaskTable
  constructor: (options) ->
    @currentTeammateId = options.currentTeammateId
    @selectors = options.selectors
    @forms = {}
    @forms[kind] = $(selector) for kind, selector of options.forms
    @setupClicks()
    @setupKeyboard()
    @setupDragDrop()

  setupClicks: ->
    $(@selectors.add).on("click", this, handlers.addTask)
    $(@selectors.edit).on("click", this, handlers.editTask)
    $(@selectors.destroy).on("click", this, handlers.destroyTask)
    $(@selectors.teammate).on("click", this, handlers.selectTeammate)

  setupKeyboard: ->
    $(@selectors.input).on("keyup", this, handlers.cancelEditOnEscape)

  setupDragDrop: ->
    $(@selectors.task).draggable
      axis: "x"
      handle: @selectors.handle
      cursor: "move"
      revert: "invalid"
      revertDuration: 150
      appendTo: @selectors.wrapper
      helper: (event) ->
        target = $(event.currentTarget)
        content = target.find(".task-content").text()
        colorClass = ""
        for value in target.attr("class").split(" ")
          colorClass = value if value.indexOf("show-color-") is 0
        [width, height] = [target.outerWidth(), target.outerHeight()]
        $("<div/>")
          .offset(target.offset())
          .addClass("task-helper")
          .addClass(colorClass)
          .css(width: width, height: height)
          .append($('<div class="task-content" />').text(content))
      start: (event, ui) =>
        console.log "start", event.target
        target = $(event.target)
        tasks = target.parent()
          .find(@selectors.task)
          .not(event.target)
          .not("*[data-blank]")
        [width, height] = [target.outerWidth(), target.outerHeight() - 1]
        targetContent = """
          <div class="target-outer">
            <div class="target-left">&nbsp;</div>
          </div>
          <div class="target-outer">
            <div class="target-right">&nbsp;</div>
          </div>
        """
        tasks.each (index, task) =>
          task = $(task)
          offset = task.offset()
          $("<div/>")
            .addClass("task-target")
            .width(width / 2)
            .height(height)
            .offset(top: offset.top + 1, left: offset.left - (width / 4))
            .append($(targetContent))
            .appendTo(@selectors.wrapper)
            .droppable(accept: @selectors.task, hoverClass: "task-hovering")
      stop: (event, ui) =>
        console.log "stop", event.target
        # $(@selectors.wrapper).find(".task-target").remove()

  pushCurrentTask: (@currentTask) ->

  popCurrentTask: ->
    [task, @currentTask] = [@currentTask, null]
    task

  updateCurrentTask: (attributes) ->
    $.extend(@currentTask, attributes) if @currentTask?

  setTeammateIdForCurrentTask: (teammateId) ->
    @currentTask?.teammateId = teammateId

handlers =
  addTask: (event) ->
    {forms, selectors} = table = event.data
    task = $(event.target).closest(selectors.task)
    table.pushCurrentTask
      action: forms.create.data("url").replace(/__taskable_story_id__/, task.data("taskableStoryId"))
      position: "last"
    handlers.setEditMode(table, task, selectors)

  editTask: (event) ->
    {forms, selectors} = table = event.data
    task = $(event.target).closest(selectors.task)
    table.pushCurrentTask
      action: forms.update.data("url")
        .replace(/__taskable_story_id__/, task.data("taskableStoryId"))
        .replace(/__id__/, task.data("taskId"))
    handlers.setEditMode(table, task, selectors)

  setEditMode: (table, task, selectors) ->
    [width, height] = [task.innerWidth() - 4, task.innerHeight() - 6]
    task
      .find(selectors.command).hide().end()
      .find(selectors.content).hide().end()
      .find(selectors.input)
        .show()
        .width(width)
        .height(height)
        .select()
        .one("blur", table, handlers.createTask)

  cancelEditOnEscape: (event) ->
    if event.keyCode is 27 # escape
      {selectors} = event.data
      task = $(event.target).closest(selectors.task)
      task
        .find(selectors.command).show().end()
        .find(selectors.content).show().end()
        .find(selectors.input)
          .hide()
          .off("blur", handlers.createTask)

  selectTeammate: (event) ->
    teammateId = $(event.target).data("teammateId")
    event.data.setTeammateIdForCurrentTask(teammateId)

  createTask: (event) ->
    {forms, selectors, currentTeammateId} = table = event.data
    task = $(event.target).closest(selectors.task)
    input = task.find(selectors.input)
    [description, hours] = handlers.parseDescription(input.val())
    table.updateCurrentTask
      description: description
      hours:       hours
      status:      task.data("status")
      teammateId:  task.data("teammateId") || currentTeammateId

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

  destroyTask: (event) ->
    {forms, selectors} = event.data
    task = $(event.target).closest(selectors.task)
    action = forms.destroy.data("destroy")
      .replace(/__taskable_story_id__/, task.data("taskableStoryId"))
      .replace(/__id__/, task.data("taskId"))
    forms.destroy
      .attr(action: action)
      .submit()

  parseDescription: (value) ->
    if (match = value.match(/^(.*)\s+(([\d\.]+)\s*h?)$/))
      [match[1], match[3] || 0]
    else
      [value, 0]
