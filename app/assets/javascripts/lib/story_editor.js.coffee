#= require ./modal_editor

class @App.StoryEditor extends @App.ModalEditor
  postConstructor: ->
    @points = @box.find(".point-selector")
    @points.on "click", ".btn", (event) ->
      target = $(event.currentTarget)
      $("#story_points").val(target.data("value"))

  postInitializeFields: (story) ->
    @points.find("button").removeClass("active")
    @points.find("button[data-value=#{story.points}]").addClass("active")

  resource: "story"

  resourceFields: [
    "description",
    "tech_lead_id",
    "product_manager_id",
    "business_driver",
    "spec_link",
    "points"
  ]
