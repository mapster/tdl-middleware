require 'test_helper'

class JcoruProxyTest < ActionDispatch::IntegrationTest
  
  def setup
    @jcoru_proxy = JcoruProxy.new
  end
  
  test "should return a jsonReport" do
    assert_not_empty JSON.parse(@jcoru_proxy.run_junit source_files(:my_class_test, :my_class))["junitReport"]
  end
  
  test "should return a compilationReport for compilation errors" do
    assert_not_empty JSON.parse(@jcoru_proxy.run_junit [source_files(:my_class_test)])["compilationReport"]
  end
  
  test "should return server error report if could not connect" do
    @jcoru_proxy = JcoruProxy.new "http://localhost:49999"
    assert_not_empty JSON.parse(@jcoru_proxy.run_junit source_files(:my_class_test, :my_class))["server_error"]
  end
end