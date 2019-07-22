SwaggerUiEngine.configure do |config|
  config.admin_username = ENV['ADMIN_USERNAME']
  config.admin_password = ENV['ADMIN_PASSWORD']
  config.doc_expansion = 'full'
  config.model_rendering = 'model'
  config.validator_enabled = true

  config.swagger_url = {
    v1: '/doc/api/v1/swagger.yaml'
  }
end
