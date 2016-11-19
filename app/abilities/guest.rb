class Guest < Ability
  def initialize(_user)
    can :read, :all
  end
end
