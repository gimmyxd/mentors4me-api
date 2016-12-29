class MentorFactory < Ability
  def initialize(user)
    can :read, :all
    can [:create], User
    can :update, Mentor, mentor: user.mentor
    can [:update, :password], User, id: user.id
    can [:accept, :reject], Context, mentor_id: user.mentor.id
  end
end
