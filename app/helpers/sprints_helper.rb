module SprintsHelper
  def current_teammate
    @current_teammate ||= begin
      if current_account && current_account.teammate
        current_account.teammate.decorate
      else
        NonTeammateDecorator.new
      end
    end
  end
end
