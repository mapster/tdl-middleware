require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
    setup :activate_authlogic

    # index
    #
    test "index forbidden for normal user" do
        UserSession.create users(:jolly)
        get :index
        assert_response :not_found
    end

    test "index allowed for authorized user" do
        UserSession.create manager
        get :index
        assert_response :success
    end

    # show
    #
    test "show forbidden for normal user" do
        UserSession.create users(:jolly)
        get :show, path_params(fixture)
        assert_response :not_found
    end

    test "show allowed for authorized user" do
        UserSession.create manager
        get :show, path_params(fixture)
        assert_response :success
    end

    # create
    #
    test "create forbidden for normal user" do
        UserSession.create users(:jolly)
        create fixture
        assert_response :not_found
    end

    test "create allowed for authorized user" do
        UserSession.create manager
        create fixture
        assert_response :success
    end

    # update
    #
    test "update forbidden for normal user" do
        UserSession.create users(:jolly)
        update fixture
        assert_response :not_found
    end

    test "update allowed for authorized user" do
        UserSession.create manager
        update fixture
        assert_response :success
    end

    # delete
    #
    test "delete forbidden for normal user" do
        UserSession.create users(:jolly)
        delete :destroy, path_params(fixture)
        assert_response :not_found
    end

    test "delete allowed for authorized user" do
        UserSession.create manager
        delete :destroy, path_params(fixture)
        assert_response :success
    end
    private
    def manager
        users(:user_manager)
    end

    def fixture
        users(:jolly)
    end

    def path_params user
        {'id' => user.id}
    end

    def create (user)
        user.email = "another@email.com"
        user = user.as_json.merge({:password => "password123", :password_confirmation => "password123"})
        post_json :create, nil, user
    end

    def update (user)
        put_json :update, path_params(user), user.as_json
    end
end
