class TaskTableService
  attr_reader :taskable_stories
  attr_reader :cols, :col_width

  def initialize(taskable_stories)
    @taskable_stories = taskable_stories
    @cols = 1
    @col_width = 145
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
      block.call(taskable_story.story.decorate, tasks)
    end
  end

  def table_properties(*column_widths)
    width = column_widths.map { |width| 1 + 8 + width + 8 }.sum
    width += 3 * (5 + col_width * cols)
    {style: "width: #{width}px;"}
  end
end
