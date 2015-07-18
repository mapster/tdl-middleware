class ExercisesController < ResourceBaseController 
    MODIFIABLE = ["name", "title", "kind", "difficulty", "description"]
    @@modifiable = ["name", "title", "kind", "difficulty", "description"]
    @@required = @@modifiable

    before_filter :get_exercise, only: [:show, :update, :destroy]
    before_filter :authorized_to_manage_exercises, only: [:create, :update, :destroy]

    def index
        render json: Exercise.all
    end

    def show
        render json: @exercise
    end

    def create
        @exercise = Exercise.new(@json)

        if @exercise.valid? and @exercise.save
            render json: @exercise, status: :created, :location => exercise_path(@exercise)
        else
            render json: @exercise.errors.messages, status: :conflict
        end
    end

    def update
        if @exercise.update(@json)
            render json: @exercise
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
    def authorized_to_manage_exercises
        render nothing: true, status: :forbidden unless authorized? :manage_exercises
    end

    def get_exercise
        @exercise = Exercise.find(params[:id])
    end
end
