class ExercisesController < ResourceBaseController 
    @@modifiable = ["name", "title", "kind", "difficulty", "description"]
    @@required = @@modifiable

    before_filter :get_exercise, only: [:show, :update, :destroy]

    def index
        render json: Exercise.all
    end

    def show
        render json: @exercise
    end

    def create
        @exercise = Exercise.new(@json)

        if @exercise.valid? and @exercise.save
            redirect_to @exercise
        else
            render json: @exercise.errors.messages, status: :conflict
        end
    end

    def update
        if @exercise.update(@json)
            redirect_to @exercise
        else
            render json: @exercise.errors.messages, status: :bad_request
        end
    end

    def destroy
        if @exercise.destroy
            render nothing: true, status: :no_content
        else
            render nothing: true, status: :internal_server_error
        end
    end

    private
    def get_exercise
        @exercise = Exercise.find(params[:id])
    end
end
