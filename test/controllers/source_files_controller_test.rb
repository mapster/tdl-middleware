require 'test_helper'

class SourceFilesControllerTest < ActionController::TestCase
    setup :activate_authlogic
    include AuthorizationTest

    test "should get index" do
        get_json :index, path_params(fixture)
        assert_response :success
    end

    test "should get source_file" do
        get_json :show, path_params(fixture)
        assert_response :success
    end
    
    test "should respond with :not_found for show non existing" do
        get_json :show, {'id' => 1, 'exercise_id' => fixture.exercise_id}
        assert_response :not_found
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

    private

    def create source_file
        post_json :create, {'exercise_id' => source_file.exercise_id}, select_fields(source_file, SourceFilesController::MODIFIABLE)
    end

    def update source_file
        put_json :update, path_params(source_file), select_fields(source_file, SourceFilesController::MODIFIABLE)
    end

    def manager
        users(:exercise_manager)
    end

    def fixture
        source_files(:sf1)
    end

    def path_params source_file
        {'id' => source_file.id, 'exercise_id' => source_file.exercise_id}
    end
    
    def path_from_response 
        sf = SourceFile.new JSON.parse(response.body)
        exercise_source_file_path(sf.exercise, sf)
    end

end
