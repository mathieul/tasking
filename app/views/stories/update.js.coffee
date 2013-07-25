App.pageUpdateManager.refreshMain
  controllerName: "<%= controller_name %>"
  modal: "#editor"
  replace: [
    "#main"
    "<%= escape_javascript render('stories', stories: @stories, velocity: @velocity) %>"
  ]
  highlight: "#<%= dom_id @story %>"
  newUrl: "<%= stories_url %>"
