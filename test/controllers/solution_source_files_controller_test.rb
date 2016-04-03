require 'test_helper'

class SolutionSourceFilesControllerTest < ActionController::TestCase
    # include SourceFilesBaseTest
    
    private

    def create source_file
        post_json :create, {'solution_id' => source_file.exercise_id}, select_fields(source_file, SolutionSourceFilesController::MODIFIABLE)
    end
    
    # def update source_file
        # put_json :update, path_params(source_file), select_fields(source_file, SourceFilesController::MODIFIABLE)
    # end
# 
    def manager
        users(:exercise_manager)
    end
 
    def fixture
        source_files(:sf1)
    end
 
    def path_params source_file
        # TODO source_set_id is incorrect here, should be the exercise_id of the solution that has source_set_id
        {'id' => source_file.id, 'solution_id' => source_file.source_set_id}
    end
     
    # def path_from_response 
        # sf = SourceFile.new JSON.parse(response.body)
        # exercise_source_file_path(sf.exercise, sf)
    # end
end
