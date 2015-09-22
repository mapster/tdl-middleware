require 'test_helper'

class Admin::UserAuthorizationsControllerTest < ActionController::TestCase
    setup :activate_authlogic
    include AdminAuthorizationTest

    test "user should only have one associated auth after update" do
        auth = user_authorizations(:auth_user_manager)
        update(auth)
        
        user_auths = UserAuthorization.where(user_id: auth.user_id) 
        assert_equal 1, user_auths.size
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

    def update (user_auth)
        path_params = {'user_id' => user_auth.user_id}
        post_json :update, path_params, select_fields(user_auth, Admin::UserAuthorizationsController::MODIFIABLE)
    end

    def test_actions
        [:show, :update, :destroy]
    end

end
