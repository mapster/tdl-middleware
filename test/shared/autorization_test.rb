module AuthorizationTest
    extend ActiveSupport::Concern

    included do
        setup :activate_authlogic
        ## delete

        test "normal user should not be allowed to delete" do
            UserSession.create users(:jolly)
            delete :destroy, path_params(fixture) 
            assert_response :forbidden
        end 

        test "authorized user should be allowed to delete" do
            UserSession.create manager
            delete :destroy, path_params(fixture)
            assert_response :success
        end 

        test "unauthenticated request should not be allowed to delete" do
            delete :destroy, path_params(fixture)
            assert_response :unauthorized
        end 


        ## update

        test "normal user should not be allowed to update" do
            UserSession.create users(:jolly)
            update fixture
            assert_response :forbidden
        end

        test "authorized user should be allowed to update" do
            UserSession.create manager
            update fixture
            assert_response :success
        end

        test "unauthenticated request should not be allowed to update" do
            update fixture
            assert_response :unauthorized
        end

        ## create 

        test "create should return created with location in header" do
            UserSession.create manager 
            create fixture
            assert_response :created
            assert_equal path_from_response, response.location
        end

        test "normal user should not be allowed to create" do
            UserSession.create users(:jolly)
            create fixture
            assert_response :forbidden
        end

        test "authorized user should be allowed to create" do
            UserSession.create manager
            create fixture
            assert_response :success
        end

        test "unauthenticated request should not be allowed to create" do
            create fixture
            assert_response :unauthorized
        end

    end
end
