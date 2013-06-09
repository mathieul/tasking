@App.WiselinksManager =
  setup: ->
    @manager = new Manager
    @manager.listenToPageEvents()

class Manager
  constructor: ->
    window.wiselinks ?= new Wiselinks($('body'), html4: false)

  listenToPageEvents: ->
    scrollInfo = []
    page = $(document)
    page
      .off("page:loading")
      .on "page:loading", (event, target, render, url) ->
        scrollInfo.length = 0
        $(".preserve-scroll").each (index, obj) ->
          $obj = $(obj)
          scrollInfo.push
            id:   obj.id
            top:  $obj.scrollTop()
            left: $obj.scrollLeft()

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
        for scroll in scrollInfo
          $("##{info.id}")
            .scrollTop(scroll.top)
            .scrollLeft(scroll.left)

    page
      .off("page:fail")
      .on "page:fail", (event, target, status, url, error) ->
        console.log "Failure: status is '#{status}'"
