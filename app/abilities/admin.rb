class Admin < Ability
  def initialize(_user)
    can :manage, :all
  end
end
