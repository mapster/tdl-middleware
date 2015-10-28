require 'test_helper'

class SolutionsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def setup
    @user = users :jolly
    @ex_missing_solution = exercises(:ex_missing_solution)
    UserSession.create @user
  end

  test ":show should create solution for exercise if it does not exist" do
    get_json :show, {:id => @ex_missing_solution}
    assert_equal @ex_missing_solution.id, assigns(:solution).exercise_id
  end  
  
  test ":show should create a solution with the current user as owner" do
    get_json :show, {:id => @ex_missing_solution}
    assert_equal @user.id, assigns(:solution).user_id 
  end
  
  test ":show should return not found for non existing exercise_id" do
    get_json :show, {:id => 1}
    assert_response :not_found
  end
  
  test ":show should return existing solution" do
    get_json :show, {:id => exercises(:ex1)}
    assert_equal solutions(:jolly_ex1_solution).id, assigns(:solution).id 
  end
  
  test ":index should be successful" do
    get_json :index
    assert_response :success
  end
  
  test ":index should return all user solutions" do
    get_json :index
    assert_includes assigns(:solutions), solutions(:jolly_ex1_solution)
    assert_includes assigns(:solutions), solutions(:jolly_ex2_solution)
  end
  
  test ":index should not return other user's soultions" do
    get_json :index
    assert_not_includes assigns(:solutions), solutions(:happy_ex1_solution)
  end
  
  # TODO Replace with AuthenticationTest module
  test ":show should be forbidden for unauthenticated request" do
    UserSession.find.destroy
    get_json :show, {:id => exercises(:ex1)}
    assert_response :unauthorized
  end
  
  test ":index should be forbidden for unauthenticated request" do
    UserSession.find.destroy
    get_json :index
    assert_response :unauthorized
  end
end
