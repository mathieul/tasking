App.pageUpdateManager.refreshMain
  controllerName: "<%= controller_name %>"
  replace: [
    "#main"
    "<%= escape_javascript render('stories', stories: @stories, velocity: @velocity) %>"
  ]
  newUrl: "<%= stories_url %>"
