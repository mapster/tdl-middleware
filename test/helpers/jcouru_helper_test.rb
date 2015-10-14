require 'test_helper'

class JcouruHelperTest < ActionView::TestCase
  include JcoruHelper
  
  test "should return a jsonReport" do
    assert_not_empty JSON.parse(jcoru_test source_files(:my_class_test, :my_class))["junitReport"]
  end
  
  test "should return a compilationReport for compilation errors" do
    assert_not_empty JSON.parse(jcoru_test [source_files(:my_class_test)])["compilationReport"]
  end
  
  test "should return server error report if could not connect" do
    # not happy with this way of overriding the config
    orig = Rails.configuration.jcoru_url
    Rails.configuration.jcoru_url = "http://localhost:49999"
    begin
      assert_not_empty JSON.parse(jcoru_test source_files(:my_class_test, :my_class))["server_error"]
    ensure
      Rails.configuration.jcoru_url = orig
    end
  end
end