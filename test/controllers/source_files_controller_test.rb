require 'test_helper'

class SourceFilesControllerTest < ActionController::TestCase
    setup :activate_authlogic
    include AuthorizationTest

    test "should get index" do
        get :index, path_params(fixture)
        assert_response :success
    end

    test "should get source_file" do
        get :show, path_params(fixture)
        assert_response :success
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
