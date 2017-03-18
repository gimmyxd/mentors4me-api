# frozen_string_literal: true
class AdminFactory < Ability
  def initialize(_user)
    can :manage, :all
  end
end
