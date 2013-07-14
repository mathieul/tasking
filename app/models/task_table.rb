class TaskTable
  KINDS = %w[todo in_progress done]

  attr_reader :sprint, :col_width

  def initialize(sprint, col_width: 145)
    @sprint = sprint
    @col_width = col_width
  end

  def cache_key
    [col_width, KINDS.map { |kind| col_count(kind) }, sprint].join("/")
  end

  def col_count(kind)
    task_count_max[kind] + 1
  end

  def task_count_max
    @task_count_max ||= begin
      tasks = Task
        .select("tasks.taskable_story_id, tasks.status, count(tasks.id) as tasks_count")
        .joins(taskable_story: :sprint)
        .where("taskable_stories.sprint_id = ?", sprint.id)
        .group("tasks.taskable_story_id, tasks.status")
      max_counts = tasks.group_by(&:status).map do |kind, story_tasks|
        [kind, story_tasks.map(&:tasks_count).max]
      end
      Hash.new(0).merge(Hash[max_counts])
    end
  end

  def render_header(kind)
    %Q{<th colspan="#{col_count(kind)}">#{kind.to_s.humanize}</th>}.html_safe
  end

  def each_story_and_tasks(teammate = nil, &block)
    teammate_id = teammate && teammate.id
    sprint.taskable_stories.each do |taskable_story|
      per_status = taskable_story.tasks.ranked.decorate.group_by(&:status)
      tasks = KINDS.each.with_object({}) do |kind, tasks|
        story_tasks = per_status[kind] || []
        count_missing = col_count(kind) - story_tasks.length
        new_task = Task.new(status: kind, teammate_id: teammate_id).decorate
        tasks[kind] = story_tasks + [new_task] * count_missing
      end
      block.call(taskable_story, taskable_story.story.decorate, tasks)
    end
  end

  def table_properties(*column_widths)
    width = column_widths.map { |width| 1 + 8 + width + 8 }.sum
    width += KINDS.map { |kind| 5 + col_width * col_count(kind) }.sum
    {style: "width: #{width}px;"}
  end
end
