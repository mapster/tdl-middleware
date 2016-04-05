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
    
    @mock = JcoruMock.new
    @mock.report = TEST_REPORT
    @controller.jcoru_proxy = @mock 
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
    create new_fixture
    assert_response :created
  end
    
  test "create should return a SolveAttempt with a new id" do
    create new_fixture
    id = JSON.parse(response.body)['id']
    assert id.is_a? Numeric
    assert_not_nil SolveAttempt.find_by(id: id)
  end
  
  test "create should return location in header" do
    create new_fixture
    assert_equal users_solution_solve_attempt_path(@solution.exercise_id, JSON.parse(response.body)['id']), response.location
  end
  
  test "create should fail with not found for non-existing solution" do
    create SolveAttempt.new(:solution => Solution.new(:exercise_id => 1), :source_files => source_files(:my_class, :my_class_test))
    assert_response :not_found
  end
  
  test "create should require source_files" do
    post_json :create, {:solution_id => @solution.exercise_id},{}
    assert_response :bad_request
  end
  
  test "create should store solve_attempt in database" do
    create new_fixture
    assert SolveAttempt.exists?(JSON.parse(response.body)['id'])
  end
  
  test "create should store source_files in database" do
    create new_fixture
    created_attempt = SolveAttempt.find(JSON.parse(response.body)['id'])
    assert_not_nil created_attempt.source_files
    assert_not_empty created_attempt.source_files
    assert_equal new_fixture.source_files.first.name, created_attempt.source_files.first.name
  end
  
  test "create should accept empty source_files" do
    create SolveAttempt.new(:solution => @solution)
    assert_response :created
  end
  
  test "creates should respond with bad_request if source_file is invalid" do
    create SolveAttempt.new(:solution => @solution, :source_files => [SourceFile.new(:contents => "bla bla")])
    assert_response :bad_request
    assert_nil SolveAttempt.find_by(id: assigns(:solve_attempt).id)
  end
  
  test "create should add the test report" do
    create new_fixture
    assert_equal TEST_REPORT, assigns(:solve_attempt).report
  end
  
  test "create should send exercise sources to jcoru" do
    create new_fixture
    @solution.exercise.source_files.map { |sf| assert_includes @mock.test_files, sf } 
  end
  
  test "create should set solution for solve attempt" do
    create new_fixture
    assert_equal @solution, assigns(:solve_attempt).solution
  end
  
  test "create should not accept overriding exercise sources" do
    create SolveAttempt.new(:solution => @solution, :source_files => (@solution.exercise.source_files | source_files(:my_class, :my_class_test)))
    assert_response :bad_request
    assert_nil SolveAttempt.find_by(id: assigns(:solve_attempt).id)
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
    attempt[:source_files] = solve_attempt.source_files.map { |sf| select_fields(sf, ["name", "contents"]) }
    post_json :create, {'solution_id' => solve_attempt.solution.exercise_id}, attempt 
  end
  
  def fixture
    solve_attempts(:jolly_ex1_attempt1)
  end
  
  def path_params solve_attempt
    {'id' => solve_attempt.id, 'solution_id' => solve_attempt.solution.exercise_id}
  end
  
  def new_fixture
    SolveAttempt.new(:solution => @solution, :source_files => source_files(:my_class, :my_class_test))
  end
end
