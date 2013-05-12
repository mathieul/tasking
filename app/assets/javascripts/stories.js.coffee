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

class StoryEditor
  constructor: (selector) ->
    @box = $(selector)
    @points = @box.find("#point-selector")

  newStory: (attributes) ->
    @initializeForm(attributes)
    @box.modal("show")

  initializeForm: (story) ->
    for field in @storyFields
      @box.find("*[name=\"story[#{field}]\"]").val(story[field])
    @points.find("button").removeClass("active")
    @points.find("button[data-value=#{story.points}]").addClass("active")

  storyFields: [
    "description",
    "tech_lead_id",
    "product_manager_id",
    "business_driver",
    "spec_link",
    "points"
  ]
