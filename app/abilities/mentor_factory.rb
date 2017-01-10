class MentorFactory < Ability
  def initialize(user)
    can :read, :all
    can [:create], User
    can :update, Mentor, mentor: user.mentor
    can [:update, :password], User, id: user.id
    can [:show, :accept, :reject], Context, mentor_id: user.id
  end
end
