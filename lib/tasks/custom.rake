desc 'Generate user roles'
task generate_user_roles: :environment do
  messages = Role.generate_user_roles
  messages.each { |msg| puts msg }
end
