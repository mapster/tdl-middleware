require 'test_helper'

class Admin::UserAuthorizationsControllerTest < ActionController::TestCase
    setup :activate_authlogic
    include AdminAuthorizationTest

    test "create should delete old auth if it exists" do
        flunk "test needs to be implemented"
    end

    private
    def manager
        users(:auth_manager)
    end

    def fixture
        user_authorizations(:auth_jolly)
    end

    def path_params user_auth
        {'id' => user_auth.id, 'user_id' => user_auth.user_id}
    end

    def create (user_auth)
        path_params = {'user_id' => user_auth.user_id}
        post_json :create, path_params, select_fields(user_auth, Admin::UserAuthorizationsController::MODIFIABLE)
    end

    def update (user_auth)
        create user_auth
    end

    def test_actions
        [:show, :create, :destroy]
    end

end
