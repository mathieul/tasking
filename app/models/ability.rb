class Ability
  include CanCan::Ability

  def initialize(account)
    account ||= Account.new
    if user.admin?
      can :manage, :all
    else
      can :manage, :stories
      can :manage, :task_stories
      can :manage, :tasks
      can :update, Account do |candidate|
        candidate.id == account.id
      end
      can :update, Teammate do |candidate|
        candidate.id == account.teammate.try(:id)
      end
    end
  end
end
