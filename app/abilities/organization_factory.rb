# frozen_string_literal: true

class OrganizationFactory < Ability
  def initialize(user)
    can :read, :all
    can [:create], User
    can %i[update deactivate], Organization, organization: user.organization
    can %i[update password destroy deactivate], User, id: user.id
    can :manage, Context, organization_id: user.id
  end
end
