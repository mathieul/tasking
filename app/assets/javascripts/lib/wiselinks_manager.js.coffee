@App.WiselinksManager =
  setup: ->
    @manager = new Manager
    @manager.listenToPageEvents()

class Manager
  constructor: ->
    window.wiselinks ?= new Wiselinks($('body'), html4: false)

  listenToPageEvents: ->
    page = $(document)
    page
      .off("page:loading")
      .on "page:loading", (event, target, render, url) ->
        console.log "Loading: #{url} to #{target.selector} within '#{render}'"

    page
      .off("page:redirected")
      .on "page:redirected", (event, target, render, url) ->
        console.log "Redirected: to #{url}"

    page
      .off("page:always")
      .on "page:always", (event, xhr, settings) ->
        console.log "Always..."

    page
      .off("page:done")
      .on "page:done", (event, target, status, url, data) ->
        console.log "Done: status is '#{status}'"

    page
      .off("page:fail")
      .on "page:fail", (event, target, status, url, error) ->
        console.log "Failure: status is '#{status}'"
