class TaskTableService
  attr_reader :sprint, :col_width

  def initialize(sprint)
    @sprint = sprint
    @col_width = 145
  end

  def taskable_stories
    @taskable_stories ||= sprint.taskable_stories.joins(:story, :tasks)
  end

  def render_header(kind)
    %Q{<th colspan="#{cols}">#{kind.to_s.humanize}</th>}.html_safe
  end

  def each_story_and_tasks(&block)
    taskable_stories.each do |taskable_story|
      tasks = {
        todo: [nil] * cols,
        in_progress: [nil] * cols,
        done: [nil] * cols
      }
      block.call(taskable_story, taskable_story.story.decorate, tasks)
    end
  end

  def table_properties(*column_widths)
    width = column_widths.map { |width| 1 + 8 + width + 8 }.sum
    width += 3 * (5 + col_width * cols)
    {style: "width: #{width}px;"}
  end

  def tasks_status_per_taskable_story
    # => {taskable_story1: {todo: [task1, task2], in_progress: [], done: []}, ...}
  end
end
