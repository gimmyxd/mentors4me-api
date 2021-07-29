# frozen_string_literal: true

class User < ApplicationRecord
  include SharedMethods
  include TokenGenerator
  devise :database_authenticatable, :registerable, :validatable

  validates :auth_token, uniqueness: true, allow_nil: true

  has_one :mentor, dependent: :destroy, autosave: true
  has_one :organization, dependent: :destroy, autosave: true

  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  accepts_nested_attributes_for :role_assignments, allow_destroy: true

  attr_accessor :role_id

  scope :active, -> { where(active: true) }
  scope :mentor, -> { includes(:roles).where(roles: { slug: CR::MENTOR }) }
  scope :organization, -> { includes(:roles).where(roles: { slug: CR::ORGANIZATION }) }

  # Filer users by status
  # /contexts?status='status'
  def self.status(status)
    case status
    when CU::ACTIVE
      where(active: true)
    when CU::INACTIVE
      where(active: false)
    end
  end

  def contexts
    if admin?
      load_contexts.all
    else
      load_contexts.where('mentor_id = ? OR organization_id = ?', id, id)
    end
  end

  def assign_roles(role_ids)
    new_assignments = []
    Array(role_ids).each { |role_id| new_assignments << { role_id: role_id } }
    self.role_assignments_attributes = new_assignments
  end

  def full_name
    mentor.try(:full_name) || organization.try(:asignee)
  end

  def admin?
    role?(CR::ADMIN)
  end

  def mentor?
    role?(CR::MENTOR)
  end

  def organization?
    role?(CR::ORGANIZATION)
  end

  def role?(slug)
    Role.list_by(:slug, roles).key?(slug)
  end

  def deactivate
    update(active: false)
  end

  def activate
    update(active: true)
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      email: email,
      active: active,
      role: roles.pluck(:slug)
    }
    add_mentor_data(custom_response) if mentor.present?
    add_organization_data(custom_response) if organization.present?
    options.empty? ? custom_response : super
  end

  private

  def load_contexts
    Context.includes(:mentor)
  end

  def add_mentor_data(custom_response)
    add_profile_data(custom_response)
    add_skills_data(custom_response)
  end

  def add_profile_data(response)
    response[:first_name] = mentor.first_name
    response[:last_name] = mentor.last_name
    response[:phone_number] = mentor.phone_number
    response[:city] = mentor.city
    response[:description] = mentor.description
    response[:facebook] = mentor.facebook
    response[:linkedin] = mentor.linkedin
    response[:organization] = mentor.organization
    response[:position] = mentor.position
    response[:occupation] = mentor.occupation
    response[:availability] = mentor.availability
    response
  end

  def add_organization_data(response)
    response[:name] = organization.name
    response[:asignee] = organization.asignee
    response[:phone_number] = organization.phone_number
    response[:city] = organization.city
    response[:facebook] = organization.facebook
    response[:description] = organization.description
    response
  end

  def add_skills_data(response)
    response[:skills] = mentor.skills.pluck(:name).sort
  end
end
