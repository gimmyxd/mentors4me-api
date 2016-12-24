class Ability
  include CanCan::Ability

  def self.build_ability_for(user)
    user ||= User.new
    if user.admin?
      Admin.new(user)
    elsif user.mentor?
      Mentor.new(user)
    elsif user.organization?
      Normal.new(user)
    else
      Guest.new(user)
    end
  end
end
