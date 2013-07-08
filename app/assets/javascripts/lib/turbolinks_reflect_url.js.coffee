Turbolinks.reflectNewUrl = (url) ->
  if url isnt document.location.href
    referer = document.location.href
    currentState = window.history.state
    window.history.pushState { turbolinks: true, position: currentState.position + 1 }, '', url
