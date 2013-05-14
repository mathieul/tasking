@App ||= {}

editor = null
newStoryAttributes = null

@App.stories =
  init: (options = {}) ->
    editor = new StoryEditor("#edit-story-modal")
    newStoryAttributes = options.newStory || {}
    $("#new-story-button").click (event) ->
      event.preventDefault()
      editor.newStory(newStoryAttributes)
    # setup edit buttons
    $("table.hidden-commands .command").on "click", "a", (event) ->
      event.preventDefault()
      target = $(event.currentTarget)
      action = target.data("action")
      content = target.closest(".command").data("content")
      if action is "edit"
        editor.editStory(content)
      else
        console.log "TODO: execute action #{action} on", content

class StoryEditor
  constructor: (selector) ->
    @box = $(selector)
    @setupPointSelector("#point-selector")

  setupPointSelector: (selector) ->
    @points = @box.find(selector)
    @points.on "click", ".btn", (event) ->
      target = $(event.currentTarget)
      $("#story_points").val(target.data("value"))

  newStory: (attributes) ->
    @initializeForm("create")
    @initializeFields(attributes)
    @initializeLabels("create")
    @box.modal("show")

  editStory: (attributes) ->
    @initializeForm("update", attributes.id)
    @initializeFields(attributes)
    @initializeLabels("update")
    @box.modal("show")

  initializeForm: (method, id = null) ->
    form = @box.find("form")
    url = form.data(method).replace /__id__/, id
    form.prop("action", url)
    verb = form.find("input[name=_method]")
    verb.val(if method is "create" then "post" else "patch")

  initializeFields: (story) ->
    for field in @storyFields
      @box.find("*[name=\"story[#{field}]\"]").val(story[field])
    @points.find("button").removeClass("active")
    @points.find("button[data-value=#{story.points}]").addClass("active")
    @box.one "shown", =>
      @box.find('*[name="story[description]"]').select()

  initializeLabels: (method) ->
    submit = @box.find(".btn-primary")
    submit.val(submit.data(method))
    title = @box.find(".title")
    title.text(title.data(method))

  storyFields: [
    "description",
    "tech_lead_id",
    "product_manager_id",
    "business_driver",
    "spec_link",
    "points"
  ]
