App.pageUpdateManager.refreshMain
  controllerName: "sprints"
  replace: [
    "#task-table-wrapper"
    "<%= escape_javascript render('tasks/task_table', task_table: @task_table) %>"
  ]
  highlight: "#<%= dom_id @taskable_story %>"
