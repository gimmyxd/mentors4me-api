class MentorFactory < Ability
  def initialize(user)
    can :read, :all
    can [:me, :create], User
    can :create, Mentor
    can :update, Mentor, mentor: user.mentor
    can [:update, :destroy], User, id: user.id
    can [:accept, :reject], Context, mentor_id: user.mentor.id
  end
end
