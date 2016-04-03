module AuthenticationTest
    extend ActiveSupport::Concern

    included do

        # index
        #
        test "index forbidden for unauthenticated user" do
            if test_actions.include? :index 
                ensure_no_session
                get_json :index, path_params(fixture)
                assert_response :unauthorized
            end
        end

        test "index allowed for authenticated user" do
            if test_actions.include? :index 
                UserSession.create users(:jolly)
                get_json :index, path_params(fixture)
                assert_response :success
            end
        end

        # show
        #
        test "show forbidden for unauthenticated user" do
            if test_actions.include? :show
                ensure_no_session
                get_json :show, path_params(fixture)
                assert_response :unauthorized
            end
        end

        test "show allowed for authenticated user" do
            if test_actions.include? :show
                UserSession.create manager
                get_json :show, path_params(fixture).merge({ :format => :json})
                assert_response :success
            end
        end

        # create
        #
        test "create forbidden for unauthenticated user" do
            if test_actions.include? :create
                ensure_no_session
                create fixture
                assert_response :unauthorized
            end
        end

        test "create allowed for authenticated user" do
            if test_actions.include? :create
                UserSession.create manager
                create fixture
                assert_response :success
            end
        end

        # update
        #
        test "update forbidden for unauthenticated user" do
            if test_actions.include? :update
                ensure_no_session
                update fixture
                assert_response :unauthorized
            end
        end

        test "update allowed for authenticated user" do
            if test_actions.include? :update
                UserSession.create manager
                update fixture
                assert_response :success
            end
        end

        # delete
        #
        test "delete forbidden for unauthenticated user" do
            if test_actions.include? :destroy
                ensure_no_session
                delete :destroy, path_params(fixture)
                assert_response :unauthorized
            end
        end

        test "delete allowed for authenticated user" do
            if test_actions.include? :destroy
                UserSession.create manager
                delete :destroy, path_params(fixture)
                assert_response :success
            end
        end
    end
    
    def ensure_no_session
      session = UserSession.find
      session.destroy unless session.nil?
    end

    def test_actions
        [:index, :show, :create, :update, :destroy]
    end
end
