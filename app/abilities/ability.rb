class Ability
  include CanCan::Ability

  def self.build_ability_for(user)
    if user.is? User::ADMIN
      Admin.new(user)
    elsif user.is? User::MENTOR
      Mentor.new(user)
    elsif user.is? User::NORMAL
      Normal.new(user)
    end
  end
end
