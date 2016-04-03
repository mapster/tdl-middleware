require 'test_helper'

class SolveAttemptsControllerTest < ActionController::TestCase
  setup :activate_authlogic
  include AuthenticationTest
  
  COMPILATION_REPORT = 
    '{
      "compilationReport": {
        "entries": [{
            "message":"cannot find symbol\n  symbol:   method asertTrue(boolean)\n  location: class FailTest",
            "code":"compiler.err.cant.resolve.location.args",
            "lineNumber":24,
            "columnNumber":5,
            "sourceName":"FailTest.java",
            "kind":"ERROR"
        }],
        "reportLevel":"ERROR"
      }
    }'
  TEST_REPORT = 
    '{
      "junitReport": {
        "failedTests": 2,
        "failures": [
          {
            "actual": "false",
            "expected": "true",
            "failureType": "ComparisonFailure",
            "testClassName": "FailTest",
            "testMethodName": "failingTest"
          },
          {
            "failureType": "AssertionError",
            "testClassName": "FailTest",
            "testMethodName": "failingTest2"
          }
        ],
        "ignored": 1,
        "runTime": 1,
        "tests": 3
      }
    }'
  
  
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
    assert_response :unauthorized
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
  
  #
  # => Create
  #
  
  test "create should return created" do
    post_json :create, {:solution_id => @solution.exercise_id}, new_fixture
    assert_response :created
  end
  
  test "create should return forbidden for unauthenticated request" do
    @session.destroy
    post_json :create, {:solution_id => @solution.exercise_id}, new_fixture
    assert_response :unauthorized
  end
  
  test "create should return a SolveAttempt with a new id" do
    post_json :create, {:solution_id => @solution.exercise_id}, new_fixture
    id = JSON.parse(response.body)['id']
    assert id.is_a? Numeric
    assert_not_nil SolveAttempt.find_by(id: id)
  end
  
  test "create should return location in header" do
    post_json :create, {:solution_id => @solution.exercise_id}, new_fixture
    assert_equal users_solution_solve_attempt_path(@solution.exercise_id, JSON.parse(response.body)['id']), response.location
  end
  
  test "create should require source_files" do
    post_json :create, {:solution_id => @solution.exercise_id}, Hash.new.as_json
    assert_response :bad_request
  end
  
  test "create should store source_files in database" do
    post_json :create, {:solution_id => @solution.exercise_id}, new_fixture
    created_attempt = SolveAttempt.find(JSON.parse(response.body)['id'])
    assert_not_nil created_attempt.source_files
    assert_not_empty created_attempt.source_files
    assert_equal new_fixture[:source_files].first[:name], created_attempt.source_files.first.name
  end
  
  test "create should accept empty source_files" do
    post_json :create, {:solution_id => @solution.exercise_id}, {:source_files => []}
    assert_response :created
  end
  
  test "creates should respond with bad_request if source_file is invalid" do
    post_json :create, {:solution_id => @solution.exercise_id}, {:source_files => [:contents => 'bla bla']}
    assert_response :bad_request
    assert_nil SolveAttempt.find_by(id: assigns(:solve_attempt).id)
  end
  
  test "create should add the test report" do
    def @controller.jcoru_test (x); TEST_REPORT end
    
    files = source_files(:my_class_test, :my_class).map {|f| select_fields f, ["name", "contents"]}
    post_json :create, {:solution_id => @solution.exercise_id}, {:source_files => files}
    
    assert_not_empty assigns(:solve_attempt).report
  end
  
  private
  def test_actions
    [:show, :index, :create]
  end
  
  def manager
    users(:jolly)
  end
  
  def create (solve_attempt)
    attempt = select_fields(solve_attempt, SolveAttemptsController::MODIFIABLE)
    attempt[:source_files] = [select_fields(source_files(:my_class), ["name", "contents"])]
    post_json :create, {'solution_id' => solve_attempt.solution.exercise_id}, attempt 
  end
  
  def fixture
    solve_attempts(:jolly_ex1_attempt1)
  end
  
  def path_params solve_attempt
    {'id' => solve_attempt.id, 'solution_id' => solve_attempt.solution.exercise_id}
  end
  
  def new_fixture
    {:source_files => [{
      :name => "Test1.java",
      :contents => "bla bla"
    },{
      :name => "Test2.java",
      :contents => "bla bla"
    }]}
  end
end
