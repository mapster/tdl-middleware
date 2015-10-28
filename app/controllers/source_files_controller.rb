class SourceFilesController < SourceFilesBaseController 
    before_filter :authorized_to_manage_exercises, only: [:create, :update, :destroy]

    private

    def get_source_set
        @source_set = Exercise.find_by(id: params[:exercise_id])
    end

    def get_source_file
        get_source_set unless @source_set
        @source_file = @source_set.source_files.find_by(id: params[:id])
    end
    
    def source_file_path
        exercise_source_file_path(@source_set, @source_file)
    end
      
    def authorized_to_manage_exercises
        render nothing: true, status: :forbidden unless authorized? :manage_exercises
    end

    def modifiable
        MODIFIABLE
    end

    def required
        REQUIRED
    end
end
