$("#editor").html "<%= escape_javascript render('story_form', story: @story, title: %q{Edit story ##{story.id}}) %>"
