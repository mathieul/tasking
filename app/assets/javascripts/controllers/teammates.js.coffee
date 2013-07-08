controller = null

@App.initTeammates = (options) ->
  controller = new TeammatesController(options)
  controller.run()

class TeammatesController
  run: ->
    @labelTimeTags()
    @showNowIfPresent()

  labelTimeTags: ->
    $('time').each ->
      time = $(this)
      time.text moment(time.attr("datetime")).fromNow()

  showNowIfPresent: ->
    $("#show-now").modal()
