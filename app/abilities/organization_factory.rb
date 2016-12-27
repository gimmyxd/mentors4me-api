class OrganizationFactory < Ability
  def initialize(user)
    can :read, :all
    can [:me, :create], User
    can :update, Organization, organization: user.organization
    can [:update, :destroy], User, id: user.id
  end
end
