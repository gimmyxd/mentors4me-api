class Ability
  include CanCan::Ability

  def self.build_ability_for(user)
    user ||= User.new
    ability = GuestFactory.new(user)
    begin
      klasses = user.roles.pluck(:slug)
                    .map { |role| "#{role}_factory" }
                    .map(&:classify)
                    .map(&:constantize)
      klasses.each do |klass|
        ability = ability.merge(klass.new(user))
      end
    rescue NameError => e
      puts e.message
    end
    ability
  end
end
