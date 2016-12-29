class OrganizationFactory < Ability
  def initialize(user)
    can :read, :all
    can [:create], User
    can :update, Organization, organization: user.organization
    can [:update, :password], User, id: user.id
  end
end
