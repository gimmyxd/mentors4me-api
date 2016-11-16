module Authenticable
  # Public: validates the token
  # returns - boolean
  def authenticate
    validate_token || render_unauthorized
  end

  # Public: handles invalid token
  # returns - API error
  def render_unauthorized
    headers['WWW-Authenticate'] = 'Token realm="Application"'
    raise Api::BaseController::InvalidAPIRequest.new('Unauthorized Acess', 401)
  end

  # Public: verifies validation of token
  # token - token of the user
  # returns - boolean
  def validate_token(token = nil)
    token ||= request.headers['Authorization']
    user = User.find_by(auth_token: token)
    return unless user.present?
    user[:token_created_at] + 24.hours > Time.now if user.token_created_at.present?
  end

  # Public: Devise methods overwrites
  # returns User
  def current_user
    current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end
end
