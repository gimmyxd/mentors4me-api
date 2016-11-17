module Authenticable
  # Public: validates the token
  # returns - boolean
  def authenticate
    validate_token(:auth) || render_unauthorized
  end

  def authenticate_invitation
    validate_token(:invitation, nil, 7.days) || render_unauthorized
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
  def validate_token(type, token = nil, period = 24.hours)
    token ||= request.headers['Authorization']
    return unless token
    token_type = "#{type}_token_created_at".to_sym
    user = User.find_by(auth_token: token) if type == :auth
    user = User.find_by(invitation_token: token) if type == :invitation
    return unless user.present?
    user[token_type] + period > Time.now if user[token_type].present?
  end

  # Public: Devise methods overwrites
  # returns User
  def current_user
    current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end
end
