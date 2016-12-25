class AdminFactory < Ability
  def initialize(_user)
    can :manage, :all
    can :create, :reject
  end
end
