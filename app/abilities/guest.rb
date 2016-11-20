class Guest < Ability
  def initialize(_user)
    can :read, :all
    cannot :create, :reject
  end
end
