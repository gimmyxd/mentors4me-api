# frozen_string_literal: true
class GuestFactory < Ability
  def initialize(_user)
    can :read, :all
  end
end
