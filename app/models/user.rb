class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :role, :email, :password, :password_confirmation, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, with: Devise.email_regexp
  validates :role, inclusion: { in: %w(admin mentor normal) }
  validates :auth_token, :invitation_token, uniqueness: true, allow_nil: true

  # Check profile errors after validation
  before_validation :validate_profile
  before_validation :validate_organization

  belongs_to :profile
  belongs_to :organization
  has_one :proposal

  # Public: generates an authentication token
  # returns - token for the user
  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      self.auth_token_created_at = Time.now
      break auth_token unless self.class.exists?(auth_token: auth_token)
    end
  end

  # Public: generates an invitation token
  # returns - token for the user
  def generate_invitation_token!
    loop do
      self.invitation_token = Devise.friendly_token
      self.invitation_token_created_at = Time.now
      break invitation_token unless self.class.exists?(invitation_token: invitation_token)
    end
  end

  # Type of user
  ADMIN = 'admin'.freeze
  MENTOR = 'mentor'.freeze
  NORMAL = 'normal'.freeze
  # Public: generates roles
  # Returns - Array
  def self.roles
    [ADMIN, MENTOR, NORMAL]
  end

  # Public: checks the role of the user
  # requested_role - contains the role of the user
  # returns - boolean
  def is?(requested_role)
    role == requested_role.to_s
  end

  # Public: models JSON representation of the object
  # _options - parameter that is provided by the standard method
  # returns - hash with user data
  def as_json(options = {})
    custom_response = {
      id: id,
      email: email,
      role:  role
    }
    add_profile_data(custom_response) if profile_id.present?
    add_skills_data(custom_response) if profile.skills.any?
    add_organization_data(custom_response) if organization_id .present?
    options.empty? ? custom_response : super
  end

  def normal?
    role == NORMAL
  end

  def mentor?
    role == MENTOR
  end

  private

  def add_profile_data(response)
    response[:first_name] = profile.first_name
    response[:last_name] = profile.last_name
    response[:phone_number] = profile.phone_number
    response[:city] = profile.city
    response[:description] = profile.description
    response
  end

  def add_organization_data(response)
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
    return unless normal?
    self.organization = Organization.new unless organization.present?
    return if organization.valid?
    organization.errors.each do |k, v|
      errors.add(k, v)
    end
  end
end
