class ExercisesController < ResourceBaseController 
    @@modifiable = ["name", "title", "kind", "difficulty", "description"]
    @@required = @@modifiable

    def index
        render json: Exercise.all
    end

    def show
        render json: (Exercise.find params[:id])
    rescue ActiveRecord::RecordNotFound
        render nothing: true, status: :not_found
    end

    def create
        exercise = Exercise.new(@json)

        if exercise.valid? and exercise.save
            redirect_to exercise
        else
            render json: exercise.errors.messages, status: :conflict
        end
    end

    def update
        exercise = Exercise.find(params[:id])
        if exercise.update(@json)
            redirect_to exercise
        else
            render json: exercise.errors.messages, status: :bad_request
        end
    end

    def destroy
        exercise = Exercise.find(params[:id])
        if exercise.destroy
            render nothing: true, status: :no_content
        else
            render nothing: true, status: :internal_server_error
        end
    rescue ActiveRecord::RecordNotFound
        render nothing: true, status: :not_found
    end
end
