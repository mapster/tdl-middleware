require 'test_helper'

class SolveAttemptsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def setup
    @user = users :jolly
    @solution = solutions(:jolly_ex1_solution)
    @session = UserSession.create @user
  end

  #
  # => Index
  #

  test "index should return success" do
    get_json :index, {:solution_id => @solution.exercise_id}
    assert_response :success
  end  
  
  test "index should return forbidden for unauthenticated request" do
    @session.destroy
    get_json :index, {:solution_id => @solution.exercise_id}
    assert_response :forbidden
  end  
  
  test "index should return all attempts for exercise solution" do
    get_json :index, {:solution_id => @solution.exercise_id}
    assert_includes assigns(:solve_attempts), solve_attempts(:jolly_ex1_attempt1)
    assert_includes assigns(:solve_attempts), solve_attempts(:jolly_ex1_attempt2)
  end
  
  #
  # => Show
  #

  test "show should return success" do
    get_json :show, {:solution_id => @solution.exercise_id, :id => solve_attempts(:jolly_ex1_attempt1)}
    assert_response :success
  end
  
  test "show should return forbidden for unauthenticated request" do
    @session.destroy
    get_json :show, {:solution_id => @solution.exercise_id, :id => solve_attempts(:jolly_ex1_attempt1)}
    assert_response :forbidden
  end
  
  test "show should return requested solve attempt" do
    get_json :show, {:solution_id => @solution.exercise_id, :id => solve_attempts(:jolly_ex1_attempt2)}
    assert_equal solve_attempts(:jolly_ex1_attempt2), assigns(:solve_attempt)    
  end
  
  test "show should return not found for non existing solve attempt" do
    get_json :show, {:solution_id => @solution.exercise_id, :id => 1}
    assert_response :not_found
  end
  
  test "show should return not found for solve attempt for other solution" do
    get_json :show, {:solution_id => @solution.exercise_id, :id => solve_attempts(:jolly_ex2_attempt1)}
    assert_response :not_found
  end
  
  test "show should return not found for solve attempt for other user" do 
    get_json :show, {:solution_id => @solution.exercise_id, :id => solve_attempts(:happy_ex1_attempt1)}
    assert_response :not_found
  end
end
