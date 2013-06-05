class TaskTableService
  attr_reader :taskable_stories
  attr_reader :num_columns, :column_width

  def initialize(taskable_stories)
    @taskable_stories = taskable_stories
    @num_columns = 2
    @column_width = 145
  end

  def render_header(kind)
    %Q{
      <th colspan="#{num_columns}" class="border-left" style="width: #{column_width * num_columns}px">
      #{kind.to_s.humanize}
      </th>
      }.html_safe
  end

  def each_story_and_tasks(&block)
    taskable_stories.each do |taskable_story|
      tasks = {
        todo: [nil] * num_columns,
        in_progress: [nil] * num_columns,
        done: [nil] * num_columns
      }
      block.call(taskable_story.story.decorate, tasks)
    end
  end

  def table_properties(existing_width)
    width = existing_width + column_width * 3 * num_columns
    {style: "width: #{width}px;"}
  end
end
