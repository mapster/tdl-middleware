class SolutionSourceFilesController < SourceFilesBaseController 
    private

    def get_source_set
        @source_set = Solution.find_by(user_id: current_user.id, exercise_id: params[:solution_id])
    end

    def get_source_file
        get_source_set unless @source_set
        @source_file = @source_set.source_files.find_by(id: params[:id])
    end
    
    def source_file_path
        users_solution_source_file_path(@source_set, @source_file)
    end

    def modifiable
        MODIFIABLE
    end

    def required
        REQUIRED
    end
end