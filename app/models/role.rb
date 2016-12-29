class Role < ApplicationRecord
  include SharedMethods

  validates :slug, presence: true, uniqueness: true, length: { maximum: 50 }
  has_many :role_assignments
  has_many :users, through: :role_assignments, dependent: :restrict_with_exception

  def self.admin
    Role.find_by(slug: CR::ADMIN)
  end

  def self.mentor
    Role.find_by(slug: CR::MENTOR)
  end

  def self.organization
    Role.find_by(slug: CR::ORGANIZATION)
  end

  def self.list_by(type = :slug, roles = nil)
    role_list = {}

    if [:slug, :id].include?(type)
      roles ||= Role.all
      roles.each do |role|
        role_list[role.try(type)] = I18n.t("roles.#{role.slug}")
      end
    end

    role_list
  end

  def self.generate_user_roles
    roles = [
      CR::ADMIN,
      CR::MENTOR,
      CR::ORGANIZATION
    ]

    messages = []

    roles.each do |key|
      role = Role.new
      role.slug = key
      messages << "Create role #{role.slug}"

      if role.save
        messages << "Role: #{role.slug} created"
      else
        messages += role.errors.full_messages
      end
    end

    messages
  end
end
