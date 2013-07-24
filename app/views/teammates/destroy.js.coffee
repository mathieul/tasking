App.pageUpdateManager.refreshMain
  controllerName: "<%= controller_name %>"
  replace: [
    "#main"
    "<%= escape_javascript render('teammates_list', teammates: @teammates) %>"
  ]
  prepend: [
    "#page-description"
    "<%= escape_javascript flash_messages %>"
  ]
  newUrl: "<%= teammates_url %>"
