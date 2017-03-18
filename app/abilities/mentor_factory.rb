# frozen_string_literal: true
class MentorFactory < Ability
  def initialize(user)
    can :read, :all
    can [:create], User
    can [:update, :deactivate], Mentor, mentor: user.mentor
    can [:update, :password, :destroy, :deactivate], User, id: user.id
    can [:show, :accept, :reject], Context, mentor_id: user.id
  end
end
