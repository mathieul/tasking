class Ability
  include CanCan::Ability

  def initialize(account)
    account ||= Account.new
    if account.admin?
      can :manage, :all
    else
      can :manage, :stories
      can :manage, :task_stories
      can :manage, :tasks
      can [:read, :update], Account do |candidate|
        candidate.id == account.id
      end
    end
  end
end
