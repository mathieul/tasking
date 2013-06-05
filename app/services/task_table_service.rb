class TaskTableService
  attr_reader :taskable_stories
  attr_reader :cols, :col_width

  def initialize(taskable_stories)
    @taskable_stories = taskable_stories
    @cols = 3
    @col_width = 145
  end

  def render_header(kind)
    %Q{
      <th colspan="#{cols}" class="border-left">
      #{kind.to_s.humanize}
      </th>
      }.html_safe
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

  def table_properties(existing_width)
    width = existing_width + col_width * 3 * cols
    {style: "width: #{width}px;"}
  end
end
