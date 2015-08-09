module AdminAuthorizationTest
    extend ActiveSupport::Concern

    included do

        # index
        #
        test "index forbidden for normal user" do
            if test_actions.include? :index 
                UserSession.create users(:jolly)
                get :index
                assert_response :not_found
            end
        end

        test "index allowed for authorized user" do
            if test_actions.include? :index 
                UserSession.create manager
                get :index, :format => :json
                assert_response :success
            end
        end

        # show
        #
        test "show forbidden for normal user" do
            if test_actions.include? :show
                UserSession.create users(:jolly)
                get :show, path_params(fixture)
                assert_response :not_found
            end
        end

        test "show allowed for authorized user" do
            if test_actions.include? :show
                UserSession.create manager
                get :show, path_params(fixture).merge({ :format => :json})
                assert_response :success
            end
        end

        # create
        #
        test "create forbidden for normal user" do
            if test_actions.include? :create
                UserSession.create users(:jolly)
                create fixture
                assert_response :not_found
            end
        end

        test "create allowed for authorized user" do
            if test_actions.include? :create
                UserSession.create manager
                create fixture
                assert_response :success
            end
        end

        # update
        #
        test "update forbidden for normal user" do
            if test_actions.include? :update
                UserSession.create users(:jolly)
                update fixture
                assert_response :not_found
            end
        end

        test "update allowed for authorized user" do
            if test_actions.include? :update
                UserSession.create manager
                update fixture
                assert_response :success
            end
        end

        # delete
        #
        test "delete forbidden for normal user" do
            if test_actions.include? :destroy
                UserSession.create users(:jolly)
                delete :destroy, path_params(fixture)
                assert_response :not_found
            end
        end

        test "delete allowed for authorized user" do
            if test_actions.include? :destroy
                UserSession.create manager
                delete :destroy, path_params(fixture)
                assert_response :success
            end
        end
    end

    def test_actions
        [:index, :show, :create, :update, :destroy]
    end
end
