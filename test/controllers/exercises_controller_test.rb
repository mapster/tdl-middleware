require 'test_helper'

class ExercisesControllerTest < ActionController::TestCase
    setup :activate_authlogic

    test "should get index" do
        get :index
        assert_response :success
    end

    test "should get exercise" do
        get :show, {'id' => ex}
        assert_response :success
    end

    # delete

    test "normal user should not be allowed to delete" do
        UserSession.create users(:jolly)
        delete :destroy, {'id' => ex}
        assert_response :forbidden
    end

    test "authorized user should be allowed to delete" do
        UserSession.create users(:exercise_manager)
        delete :destroy, {'id' => ex}
        assert_response :success
    end

    test "unauthenticated request should not be allowed to delete" do
        delete :destroy, {'id' => ex}
        assert_response :forbidden
    end

    ## update

    test "normal user should not be allowed to update" do
        UserSession.create users(:jolly)
        update ex
        assert_response :forbidden
    end

    test "authorized user should be allowed to update" do
        UserSession.create users(:exercise_manager)
        update ex
        assert_response :success
    end

    test "unauthenticated request should not be allowed to update" do
        update ex
        assert_response :forbidden
    end

    ## create 

    test "create should return created with location in header" do
        UserSession.create users(:exercise_manager)
        ex.name = "something else"
        create ex
        assert_response :created
        assert_equal exercise_path(JSON.parse(response.body)['id']), response.location
    end

    test "normal user should not be allowed to create" do
        UserSession.create users(:jolly)
        ex.name = "something else"
        create ex
        assert_response :forbidden
    end

    test "authorized user should be allowed to create" do
        UserSession.create users(:exercise_manager)
        ex.name = "something else"
        create ex
        assert_response :success
    end

    test "unauthenticated request should not be allowed to create" do
        ex.name = "something else"
        create ex
        assert_response :forbidden
    end

    private
    def create (exercise)
        post_json :create, select_fields(exercise, ExercisesController::MODIFIABLE)
    end

    def update (exercise)
        put_json :update, {'id' => exercise}, select_fields(exercise, ExercisesController::MODIFIABLE)
    end

    def ex
        exercises(:ex1)
    end

end
