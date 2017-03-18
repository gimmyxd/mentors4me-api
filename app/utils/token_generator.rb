# frozen_string_literal: true
module TokenGenerator
  def generate_authentication_token!
    loop do
      self.auth_token = Devise.friendly_token
      self.auth_token_created_at = Time.now
      break auth_token unless self.class.exists?(auth_token: auth_token)
    end
  end
end
