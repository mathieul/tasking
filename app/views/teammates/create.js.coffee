App.pageUpdateManager.refreshMain
  controllerName: "<%= controller_name %>"
  modal: "#editor"
  replace: [
    "#main"
    "<%= escape_javascript render('teammates_list', teammates: @teammates) %>"
  ]
  highlight: "#<%= dom_id @teammate %>"
  prepend: [
    "#page-description"
    "<%= escape_javascript flash_messages %>"
  ]
  newUrl: "<%= teammates_url %>"
