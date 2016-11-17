class Normal < Ability
  def initialize(user)
  can :read, :all
  end
end
