require 'test_helper'

class SolveAttemptsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  
  def setup
    @user = users :jolly
    @ex_missing_solution = exercises(:ex_missing_solution)
    @solution = solutions(:jolly_ex1_solution)
    @session = UserSession.create @user
  end

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

end
