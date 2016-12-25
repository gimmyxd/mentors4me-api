class MentorFactory < Ability
  def initialize(user)
    can :read, :all
    can [:me, :create], User
    can :create, Mentor
    can :update, Mentor, id: user.mentor
    can [:update, :destroy], User, id: user.id
    can :accept, Context, mentor_id: user.mentor.id
    cannot :create, :reject
  end
end
