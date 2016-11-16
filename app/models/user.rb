class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :role, :email, presence: true
  validates :role, inclusion: { in: %w(admin mentor normal) }
  validates :auth_token, uniqueness: true

  has_one :profile
  has_one :context

  # Public: generates an authentication token
  # returns - token for the user
  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      self.token_created_at = Time.now
      break auth_token unless self.class.exists?(auth_token: auth_token)
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
      role:  role,
      profile_id: profile_id,
      context_id: context_id
    }
    options.empty? ? custom_response : super
  end
end
