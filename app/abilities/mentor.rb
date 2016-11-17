class Mentor < Ability
  def initialize(user)
  can :read, :all
  end
end
