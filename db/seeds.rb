# frozen_string_literal: true

rake generate_user_roles

FactoryBot.create(:user, email: 'admin@example.com')
FactoryBot.create_list(:skill, 10)
FactoryBot.create_list(:user, 10, :mentor_user)
FactoryBot.create_list(:user, 10, :organization_user)
FactoryBot.create_list(:proposal, 10)
FactoryBot.create_list(:context, 10)
