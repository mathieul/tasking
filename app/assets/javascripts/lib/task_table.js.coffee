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
    $(@selectors.progress).on("click", this, handlers.progressTask)
    $(@selectors.complete).on("click", this, handlers.completeTask)
    $(@selectors.teammate).on("click", this, handlers.selectTeammate)
    $(@selectors.editStory).on("click", this, handlers.editStory)

  setupKeyboard: ->
    $(@selectors.input).on("keyup", this, handlers.cancelEditOnEscape)
    $(@selectors.storyInput).on("keyup", this, handlers.cancelStoryEditOnEscape)

  setupDragDrop: ->
    $(@selectors.task).draggable
      containment: "#task-table-wrapper"
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
          .css(width: width)
          .append($('<div class="task-content" />').text(content))
      start: (event, ui) =>
        target = $(event.target)
        tasks = target.parent()
          .find(@selectors.task)
          .not(target)
          .not(target.next(@selectors.task))
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
            .appendTo(@selectors.wrapper)
            .droppable
              accept: @selectors.task
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
        $(@selectors.wrapper).find(".task-target").remove()

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
    {forms, selectors} = table = event.data
    task = $(event.target).closest(selectors.task)
    table.pushCurrentTask
      action: forms.edit.data("createUrl").replace(/__taskable_story_id__/, task.data("taskableStoryId"))
      method: "post"
      position: "last"
    handlers.setEditMode(table, task, selectors)

  editTask: (event) ->
    {forms, selectors} = table = event.data
    task = $(event.target).closest(selectors.task)
    table.pushCurrentTask
      action: forms.edit.data("updateUrl")
        .replace(/__taskable_story_id__/, task.data("taskableStoryId"))
        .replace(/__id__/, task.data("taskId"))
      method: "patch"
    handlers.setEditMode(table, task, selectors)

  editStory: (event) ->
    {selectors} = table = event.data
    story = $(event.target).closest(selectors.story)
    [width, height] = [story.innerWidth() - 4, story.innerHeight() - 6]
    form = story.find("form.story-form")
    story
      .find(selectors.storyCommand).hide().end()
      .find(selectors.storyContent).hide().end()
      .find(selectors.storyInput)
        .show()
        .width(width)
        .height(height)
        .select()
        .one "blur", table, (event) ->
          setTimeout (->
            selectedId = table.getAndResetSelectedTeammateId()
            if selectedId?
              form.find('input[name="taskable_story[owner_id]"]').val(selectedId)
            form.get(0).submit()
          ), 250


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

  cancelStoryEditOnEscape: (event) ->
    if event.keyCode is 27 # escape
      {selectors} = event.data
      story = $(event.target).closest(selectors.story)
      story
        .find(selectors.storyCommand).show().end()
        .find(selectors.storyContent).show().end()
        .find(selectors.storyInput).hide().off("blur")

  selectTeammate: (event) ->
    teammateId = $(event.target).data("teammateId")
    event.data.setSelectedTeammateId(teammateId)

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
      selectedId = table.getAndResetSelectedTeammateId()
      task.teammateId = selectedId if selectedId?
      handlers.submitTaskForm(forms.edit, task)
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
    task = $(event.target).closest(selectors.task)
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
