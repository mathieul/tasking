controller = null

@App.initSprints = (options) ->
  window.wiselinks ?= new Wiselinks($('body'), html4: false)
  controller = new SprintsController(options)
  controller.run()

class SprintsController
  constructor: (@options) ->

  run: ->
    @initDatePickers()

  initDatePickers: ->
    $(".date .input-append").datetimepicker(pickTime: false)
