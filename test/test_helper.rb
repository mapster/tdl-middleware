ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'authlogic/test_case'
Dir[Rails.root.join("test/shared/**/**")].each {|f| require f}

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def post_json (action, path_params, payload)
      request.env['RAW_POST_DATA'] = payload.to_json
      post action, path_params
  end

  def put_json (action, path_params, payload)
      request.env['RAW_POST_DATA'] = payload.to_json
      put action, path_params
  end

  def select_fields (obj, keys)
     obj.as_json.select {|k, v| keys.include? k.to_s }
  end
end
