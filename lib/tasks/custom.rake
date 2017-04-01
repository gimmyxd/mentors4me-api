desc 'Generate user roles'
task generate_user_roles: :environment do
  messages = Role.generate_user_roles
  messages.each { |msg| puts msg }
end

desc 'Send unread messages notification'
task send_unread_messages: :environment do
  Context.send_notification
end
