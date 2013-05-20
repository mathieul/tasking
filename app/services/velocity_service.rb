class VelocityService
  attr_reader :value, :sum, :stories

  def initialize(value, stories)
    @value, @stories = value, stories
  end

  def index
    @index ||= find_index_and_calculate_sum
  end

  def cache_key
    "velocity-#{value}-#{sum}"
  end

  private

  def find_index_and_calculate_sum
    @sum = 0
    return nil if stories.empty?
    index = stories.find_index do |story|
      if @sum + story.points > value
        true
      else
        @sum += story.points
        false
      end
    end
    index.nil? ? stories.length : index
  end
end
