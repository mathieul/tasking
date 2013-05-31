#= require ../lib/wiselinks_manager

controller = null

@App.initSprints = (options) ->
  App.WiselinksManager.setup()
  controller = new SprintsController(options)
  controller.run()

class SprintsController
  constructor: (@options) ->

  run: ->
    @initDatePickers()

  initDatePickers: ->
    $(".date .input-append").datetimepicker(pickTime: false)
