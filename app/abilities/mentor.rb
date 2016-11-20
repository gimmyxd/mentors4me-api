class Mentor < Ability
  def initialize(user)
    can :read, :all
    can [:me, :create], User
    can :create, Profile
    can :update, Profile, id: user.profile_id
    can [:update, :destroy], User, id: user.id
    can :accept, Context, profile_id: user.profile_id
    cannot :create, :reject
  end
end
