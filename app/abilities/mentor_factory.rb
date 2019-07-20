# frozen_string_literal: true

class MentorFactory < Ability
  def initialize(user)
    can :read, :all
    can [:create], User
    can %i[update deactivate], Mentor, mentor: user.mentor
    can %i[update password destroy deactivate], User, id: user.id
    can %i[show accept reject], Context, mentor_id: user.id
  end
end
