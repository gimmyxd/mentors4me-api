class Ability
  include CanCan::Ability

  def self.build_ability_for(user)
    user ||= User.new
    if user.admin?
      AdminFactory.new(user)
    elsif user.mentor?
      MentorFactory.new(user)
    elsif user.organization?
      OrganizationFactory.new(user)
    else
      GuestFactory.new(user)
    end
  end
end
