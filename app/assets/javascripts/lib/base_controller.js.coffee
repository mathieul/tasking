#= require ./updater

class @App.BaseController
  setup: ->
  destroy: ->

  labelTimeTags: ->
    $('time').each ->
      time = $(this)
      time.text moment(time.attr("datetime")).fromNow()

  showEditorIfPresent: ->
    $("#editor").modal()

  autoCloseAlerts: ->
    alerts = $(".alert.auto-close")
    setTimeout (-> alerts.alert("close")), 5000

  transitionWhenClosingModals: ->
    $(document.body).on "click", ".modal a.cancel, .modal a.close", (event) ->
      event.preventDefault()
      cancel = $(this)
      cancel.closest(".modal")
        .modal("hide")
        .on "hidden", -> Turbolinks.visit cancel.attr("href")

  registerToUpdates: (controller) ->
    {roomId, sid} = $(document.body).data()
    if roomId && sid
      @updater = new App.Updater
        roomId: roomId
        sid: sid
        controller: controller
        updateSel: "#main"

  unregisterFromUpdates: ->
    @updater.destroy()
