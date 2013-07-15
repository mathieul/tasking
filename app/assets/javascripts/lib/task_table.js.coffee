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
    $(@selectors.task.add).on("click", this, handlers.addTask)
    $(@selectors.task.edit).on("click", this, handlers.editTask)
    $(@selectors.task.destroy).on("click", this, handlers.destroyTask)
    $(@selectors.task.progress).on("click", this, handlers.progressTask)
    $(@selectors.task.complete).on("click", this, handlers.completeTask)
    $(@selectors.task.teammate).on("click", this, handlers.selectTeammate)
    $(@selectors.story.edit).on("click", this, handlers.editStory)

  setupKeyboard: ->
    $(@selectors.task.input).on("keyup", this, handlers.cancelEditOnEscape)
    $(@selectors.story.input).on("keyup", this, handlers.cancelStoryEditOnEscape)

  setupDragDrop: ->
    $(@selectors.task.cell).draggable
      containment: "#task-table-wrapper"
      handle: @selectors.task.handle
      cursor: "move"
      revert: "invalid"
      revertDuration: 150
      appendTo: @selectors.task.wrapper
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
          .css(width: width)
          .append($('<div class="task-content" />').text(content))
      start: (event, ui) =>
        target = $(event.target)
        tasks = target.parent()
          .find(@selectors.task.cell)
          .not(target)
          .not(target.next(@selectors.task.cell))
        [width, height] = [target.outerWidth(), target.outerHeight() - 1]
        targetContent = """
          <div class="target-left">
            <span class="badge"><i class="icon-white" /></span>
            <span class="badge"><i class="icon-white" /></span>
          </div>
          <div class="target-right">
            <span class="badge"><i class="icon-white" /></span>
            <span class="badge"><i class="icon-white" /></span>
          </div>
        """
        targetPosition = target.data("position")
        tasks.each (index, task) =>
          task = $(task)
          taskData = task.data()
          position = taskData.position
          position -=1 if position > targetPosition
          offset = task.offset()
          $("<div/>")
            .addClass("task-target")
            .data(taskId: taskData.taskId, status: taskData.status, position: position)
            .width(width / 2)
            .height(height)
            .offset(top: offset.top + 1, left: offset.left - (width / 4))
            .append($(targetContent))
            .appendTo(@selectors.task.wrapper)
            .droppable
              accept: @selectors.task.cell
              tolerance: "intersect"
              hoverClass: "task-hovering"
              drop: (event, ui) =>
                task = ui.draggable
                url = @forms.edit.data("updateUrl")
                  .replace(/__taskable_story_id__/, task.data("taskableStoryId"))
                  .replace(/__id__/, task.data("taskId"))
                targetData = $(event.target).data()
                console.log "target data:", targetData
                console.log "url = #{url}"
                handlers.submitTaskForm @forms.edit,
                  action: url
                  position: targetData.position
                  description: null,
                  hours: null,
                  status: targetData.status
                  teammateId: null

      stop: (event, ui) =>
        $(@selectors.task.wrapper).find(".task-target").remove()

  pushCurrentTask: (@currentTask) ->

  popCurrentTask: ->
    [task, @currentTask] = [@currentTask, null]
    task

  updateCurrentTask: (attributes) ->
    $.extend(@currentTask, attributes) if @currentTask?

  setSelectedTeammateId: (@teammateId) ->

  getAndResetSelectedTeammateId: ->
    [id, @teammateId] = [@teammateId, null]
    id

handlers =
  addTask: (event) ->
    {selectors} = table = event.data
    taskCell = $(event.target).closest(selectors.task.cell)
    handlers.setEditMode(table, taskCell, selectors)

  editTask: (event) ->
    {selectors} = table = event.data
    taskCell = $(event.target).closest(selectors.task.cell)
    handlers.setEditMode(table, taskCell, selectors)

  editStory: (event) ->
    {selectors} = table = event.data
    story = $(event.target).closest(selectors.story.cell)
    [width, height] = [story.innerWidth() - 4, story.innerHeight() - 6]
    form = story.find("form.story-form")
    story
      .find(selectors.story.command).hide().end()
      .find(selectors.story.content).hide().end()
      .find(selectors.story.input)
        .show()
        .width(width)
        .height(height)
        .select()
        .one "blur", table, (event) ->
          setTimeout (->
            selectedId = table.getAndResetSelectedTeammateId()
            if selectedId?
              form.find('input[name="taskable_story[owner_id]"]').val(selectedId)
            form.submit()
          ), 250


  setEditMode: (table, taskCell, selectors) ->
    [width, height] = [taskCell.innerWidth() - 4, taskCell.innerHeight() - 6]
    data =
      form: taskCell.find("form")
      table: table
    taskCell
      .find(selectors.task.command).hide().end()
      .find(selectors.task.content).hide().end()
      .find(selectors.task.input)
        .show()
        .width(width)
        .height(height)
        .select()
        .one("blur", data, handlers.submitTask)

  cancelEditOnEscape: (event) ->
    if event.keyCode is 27 # escape
      {selectors} = event.data
      taskCell = $(event.target).closest(selectors.task.cell)
      taskCell
        .find(selectors.task.command).show().end()
        .find(selectors.task.content).show().end()
        .find(selectors.task.input).hide().off("blur", handlers.submitTask)

  cancelStoryEditOnEscape: (event) ->
    if event.keyCode is 27 # escape
      {selectors} = event.data
      story = $(event.target).closest(selectors.story.cell)
      story
        .find(selectors.story.command).show().end()
        .find(selectors.story.content).show().end()
        .find(selectors.story.input).hide().off("blur")

  selectTeammate: (event) ->
    teammateId = $(event.target).data("teammateId")
    event.data.setSelectedTeammateId(teammateId)

  submitTask: (event) ->
    {form, table} = event.data
    setTimeout (->
      selectedId = table.getAndResetSelectedTeammateId()
      form.find(".teammate-id").val(selectedId) if selectedId?
      form.submit()
    ), 250

  submitTaskForm: (form, task) ->
    form
      .attr(action: task.action)
      .find("#edit_form_method")
        .val(task.method)
        .end()
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

  runCommandOnTask: (url, method, event) ->
    {forms, selectors} = event.data
    task = $(event.target).closest(selectors.task.cell)
    action = forms.command.data(url)
      .replace(/__taskable_story_id__/, task.data("taskableStoryId"))
      .replace(/__id__/, task.data("taskId"))
    forms.command
      .attr(action: action)
      .find("#edit_form_method")
        .val(forms.command.data(method))
        .end()
      .submit()

  destroyTask: (event) ->
    handlers.runCommandOnTask("destroyUrl", "destroyMethod", event)

  progressTask: (event) ->
    handlers.runCommandOnTask("progressUrl", "progressMethod", event)

  completeTask: (event) ->
    handlers.runCommandOnTask("completeUrl", "completeMethod", event)

  parseDescription: (value) ->
    if (match = value.match(/^(.*)\s+(([\d\.]+)\s*h?)$/))
      [match[1], match[3] || 0]
    else
      [value, 0]
