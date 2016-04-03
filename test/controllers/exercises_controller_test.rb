require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
    setup :activate_authlogic
    include AuthenticationTest
    include AuthorizationTest

    test "should get index" do
        UserSession.create users(:jolly)
        get_json :index
        assert_response :success
    end

    test "should get exercise" do
        UserSession.create users(:jolly)
        get_json :show, path_params(fixture)
        assert_response :success
    end

    private
    def create (exercise)
        fixture.name = "something else"
        post_json :create, nil, select_fields(exercise, ExercisesController::MODIFIABLE)
    end

    def update (exercise)
        put_json :update, path_params(exercise), select_fields(exercise, ExercisesController::MODIFIABLE)
    end

    def manager
        users(:exercise_manager)
    end

    def new_fixture
        fixture
    end

    def fixture
        exercises(:ex1)
    end

    def path_params exercise
        {'id' => exercise.id}
    end
    
    def path_from_response
        exercise_path(JSON.parse(response.body)['id'])
    end

end
