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
      post action, json_format(path_params)
  end

  def put_json (action, path_params, payload)
      request.env['RAW_POST_DATA'] = payload.to_json
      put action, json_format(path_params)
  end
  
  def get_json (action, path_params)
      get action, json_format(path_params)  
  end

  def select_fields (obj, keys)
     obj.as_json.select {|k, v| keys.include? k.to_s }
  end
  
  private
  def json_format path_params
      path_params = Hash.new if path_params.nil?
      path_params[:format] = :json   
      path_params
  end
end
