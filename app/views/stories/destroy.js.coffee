App.pageUpdateManager.refreshMain
  controllerName: "<%= controller_name %>"
  replace: [
    "#main"
    "<%= escape_javascript render('stories', stories: @stories, velocity: @velocity) %>"
  ]
  prepend: [
    "#page-description"
    "<%= escape_javascript flash_messages %>"
  ]
  newUrl: "<%= stories_url %>"
