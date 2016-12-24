class User < ApplicationRecord
  include SharedMethods
  devise :database_authenticatable, :registerable

  validates :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: Devise.email_regexp
  validates :auth_token, uniqueness: true, allow_nil: true

  # Check profile errors after validation
  before_validation :validate_profile
  before_validation :validate_organization

  has_one :profile, dependent: :destroy
  has_one :organization, dependent: :destroy

  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  accepts_nested_attributes_for :role_assignments, allow_destroy: true

  attr_accessor :role_id

  def assign_roles(role_ids)
    new_assignments = []
    Array(role_ids).each { |role_id| new_assignments << { role_id: role_id } }
    self.role_assignments_attributes = new_assignments
  end

  # Public: generates an authentication token
  # returns - token for the user
  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      self.auth_token_created_at = Time.now
      break auth_token unless self.class.exists?(auth_token: auth_token)
    end
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

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      email: email,
      role:  roles.pluck(:slug)
    }

    add_profile_data(custom_response) if profile.present?
    add_skills_data(custom_response) if profile.present? && profile.skills.any?
    add_organization_data(custom_response) if organization .present?
    options.empty? ? custom_response : super
  end

  def deactivate
    update_attributes(active: false)
  end

  def activate
    update_attributes(active: true)
  end

  private

  def role?(slug)
    Role.list_by(:slug, roles).keys.include?(slug)
  end

  def add_profile_data(response)
    response[:profile_id] = profile.id
    response[:first_name] = profile.first_name
    response[:last_name] = profile.last_name
    response[:phone_number] = profile.phone_number
    response[:city] = profile.city
    response[:description] = profile.description
    response[:facebook] = profile.facebook
    response[:linkedin] = profile.linkedin
    response
  end

  def add_organization_data(response)
    response[:organization_id] = organization.id
    response[:name] = organization.name
    response[:asignee] = organization.asignee
    response[:phone_number] = organization.phone_number
    response[:city] = organization.city
    response[:description] = organization.description
    response
  end

  def add_skills_data(response)
    response[:skills] = profile.skills.pluck(:name)
  end

  # Private: verifies that the profile is valid. If it's not, errors are added
  # returns - hash of errors
  def validate_profile
    return unless mentor?
    self.profile = Profile.new unless profile.present?
    return if profile.valid?
    profile.errors.each do |k, v|
      errors.add(k, v)
    end
  end

  # Private: verifies that the profile is valid. If it's not, errors are added
  # returns - hash of errors
  def validate_organization
    return unless organization?
    self.organization = Organization.new unless organization.present?
    return if organization.valid?
    organization.errors.each do |k, v|
      errors.add(k, v)
    end
  end
end
