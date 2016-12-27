Apipie.configure do |config|
  config.app_name                = 'Mentors4meApi'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/apipie'
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.app_info['1.0'] = <<-EOS
     API definition.
  EOS
  config.authenticate = proc do
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end
end
