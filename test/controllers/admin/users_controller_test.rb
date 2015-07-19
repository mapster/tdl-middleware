require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
    setup :activate_authlogic
    include AdminAuthorizationTest

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
