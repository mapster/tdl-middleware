require 'test_helper'

class SolutionSourceFilesControllerTest < ActionController::TestCase
    include SourceFilesBaseTest
    include AuthenticationTest
    
    private
    
    def test_actions
      [:show, :create, :index]
    end

    def create source_file
        post_json :create, {'solution_id' => source_file.exercise_id}, select_fields(source_file, SolutionSourceFilesController::MODIFIABLE)
    end
    
    # def update source_file
        # put_json :update, path_params(source_file), select_fields(source_file, SourceFilesController::MODIFIABLE)
    # end
# 
    def manager
        users(:jolly)
    end
 
    def new_fixture
        sf = source_files(:sf1_jolly_ex1_solution).dup
        sf.name = "new name"
        sf
    end
 
    def fixture
        f = source_files(:sf1_jolly_ex1_solution)
    end
 
    def path_params source_file
        {'id' => source_file.id, 'solution_id' => source_file.exercise_id}
    end
     
    # def path_from_response 
        # sf = SourceFile.new JSON.parse(response.body)
        # exercise_source_file_path(sf.exercise, sf)
    # end
end
