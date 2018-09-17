class Ability
  include CanCan::Ability

  def initialize user
    if user.present?
      if user.admin?
        can :manage, :all
      else
        can :manage, User, id: user.id
        can :manage, Order, user_id: user.id
      end
    else
      can :read, :all
    end
  end
end
