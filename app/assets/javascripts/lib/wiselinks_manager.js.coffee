@App.WiselinksManager =
  setup: ->
    @manager = new Manager
    @manager.listenToPageEvents()

class Manager
  constructor: ->
    window.wiselinks ?= new Wiselinks($('body'), html4: false)
    Wiselinks.scrollData ||= []

  listenToPageEvents: ->
    scrollData = Wiselinks.scrollData
    page = $(document)
    page
      .off("page:loading")
      .on "page:loading", (event, target, render, url) =>
        scrollData.length = 0
        $(".preserve-scroll").each (index, node) =>
          scrollData.push
            id:   node.id
            top:  $(node).scrollTop()
            left: $(node).scrollLeft()

    page
      .off("page:redirected")
      .on "page:redirected", (event, target, render, url) ->
        console.log "Redirected: to #{url}"

    page
      .off("page:always")
      .on "page:always", (event, xhr, settings) =>
        for info in scrollData
          $("##{info.id}")
            .scrollTop(info.top)
            .scrollLeft(info.left)

    page
      .off("page:done")
      .on "page:done", (event, target, status, url, data) ->
        console.log "page:done..."
    page
      .off("page:fail")
      .on "page:fail", (event, target, status, url, error) ->
        console.log "Failure: status is '#{status}'"
