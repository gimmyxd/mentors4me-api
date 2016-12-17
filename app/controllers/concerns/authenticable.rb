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
    fail Api::BaseController::InvalidAPIRequest.new(I18n.t('api.response.unauthorized'), 401)
  end

  # Public: verifies validation of token
  # token - token of the user
  # returns - boolean
  def validate_token(token = nil)
    token ||= request.headers['Authorization']
    return unless token
    user = User.find_by(auth_token: token)
    return unless user.present?
    user[:auth_token_created_at] + 24.hours > Time.now
  end

  # Public: Devise methods overwrites
  # returns User
  def current_user
    User.find_by(auth_token: request.headers['Authorization'])
  end
end
