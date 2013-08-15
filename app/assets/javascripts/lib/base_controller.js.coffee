class @App.BaseController
  setup: ->
  teardown: ->

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

  registerToUpdates: ->
    {roomId, sid} = $(document.body).data()
    return unless roomId && sid
    @updater = new App.Updater(roomId)
    @updater.onUpdate (data) ->
      if data.from isnt sid
        url = "#{data.refresh_url}?#{(new Date).getTime()}"
        console.log "onUpdate(#{sid}): refresh[#{url}] using", data
        App.stories.teardown()
        $("#main").load url, ->
          if data.dom_id
            $("##{data.dom_id}").effect("highlight", duration: 1000)
          App.stories.setup()

  unregisterFromUpdates: ->
    @updater.destroy()
