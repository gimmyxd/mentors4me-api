class OrganizationFactory < Ability
  def initialize(user)
    can :read, :all
    can [:me, :create], User
    can :create, Organization
    can :update, User, id: user.id
    can :update, Organization, organization: user.organization
    can [:update, :destroy], User, id: user.id
    cannot :create, :reject
  end
end
