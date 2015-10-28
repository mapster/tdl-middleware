module SourceFilesBaseTest
    extend ActiveSupport::Concern

    included do
        include AuthorizationTest
        include AuthenticationTest
        
        test "should get index" do
            UserSession.create users(:jolly)
            get_json :index, path_params(fixture)
            assert_response :success
        end
    
        test "should get source_file" do
            UserSession.create users(:jolly)
            get_json :show, path_params(fixture)
            assert_response :success
        end
        
        test "should respond with :not_found for non existing source_file" do
            UserSession.create users(:jolly)
            get_json :show, path_params(SourceFile.new :id => 1, :source_set_id => fixture.exercise_id)
            assert_response :not_found
        end
    
        test "should respond with :not_found for non existing source_set" do
            get_json :show, {'id' => fixture.id, 'exercise_id' => 1}
        end
            
        test "should create source_file" do
            sf = select_fields(fixture, SourceFilesController::MODIFIABLE)
            sf["name"] = "new_name"
            
            UserSession.create manager
            put_json :update, path_params(fixture), sf
            assert_response :success
            assert_equal sf["name"], assigns(:source_file).name
        end
        
        test "should destroy source_file" do
            UserSession.create manager
            delete :destroy, path_params(fixture)
            assert_response :no_content
        end

    end
end
