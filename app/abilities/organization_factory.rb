class OrganizationFactory < Ability
  def initialize(user)
    can :read, :all
    can [:me, :create], User
    can :create, Organization
    can :update, Organization, id: user.organization_id
    can [:update, :destroy], User, id: user.id
    cannot :create, :reject
  end
end
