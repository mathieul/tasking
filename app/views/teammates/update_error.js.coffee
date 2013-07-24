<%- title = "Edit teammate #{@teammate.name.inspect}" -%>
$("#editor").html "<%= escape_javascript render('teammate_form', teammate: @teammate, title: title) %>"
