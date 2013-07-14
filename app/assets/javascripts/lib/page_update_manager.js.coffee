class PageUpdateManager
  hideModal: (selector) ->
    $(selector).addClass("fade").modal("hide")

  highlight: (selector, after = 0) ->
    setTimeout (-> $(selector).effect("highlight", duration: 2000)), after

  replace: (selector, content) ->
    $(selector).html(content)

  prepend: (selector, content) ->
    $(content).prependTo(selector)

  reflectNewUrl: (url) ->
    Turbolinks.reflectNewUrl(url)

  refreshMain: (request) ->
    controller = App[request.controllerName]
    controller.teardown();
    if request.modal
      @hideModal(request.modal)
      timer = 1000
    @replace(request.replace...) if request.replace
    @highlight(request.highlight, timer || 0) if request.highlight
    @prepend(request.prepend...) if request.prepend
    @reflectNewUrl(request.newUrl) if request.newUrl
    controller.setup();

@App.pageUpdateManager = new PageUpdateManager
