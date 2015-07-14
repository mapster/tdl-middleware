class SourceFilesController < ResourceBaseController 
    @@modifiable = ["name", "contents"]
    @@required = @@modifiable

    def index
        exercise = Exercise.find params[:exercise_id]
        render json: exercise.source_files.all
    end

    def show
        exercise = Exercise.find params[:exercise_id]
        render json: exercise.source_files.find(params[:id])
    end

    def create
        exercise = Exercise.find(params[:exercise_id])
        source_file = exercise.source_files.create!(@json)
        
        if source_file.valid?
            redirect_to exercise_source_file_path(exercise, source_file)
        else
            render json: source_file.errors.messages, status: :conflict
        end
    end

    #def update
    #    exercise = Exercise.find(params[:id])
    #    if exercise.update(@json)
    #        redirect_to exercise
    #    else
    #        render json: exercise.errors.messages, status: :bad_request
    #    end
    #end

    #def destroy
    #    exercise = Exercise.find(params[:id])
    #    if exercise.destroy
    #        render nothing: true, status: :no_content
    #    else
    #        render nothing: true, status: :internal_server_error
    #    end
    #rescue ActiveRecord::RecordNotFound
    #    render nothing: true, status: :not_found
    #end
end
