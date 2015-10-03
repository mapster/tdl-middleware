class SourceFilesController < ResourceBaseController 
    MODIFIABLE = ["name", "contents"]
    REQUIRED = MODIFIABLE

    before_filter :get_exercise, only: [:index, :show, :create, :update, :destroy]
    before_filter :get_source_file, only: [:show, :update, :destroy]
    before_filter :authorized_to_manage_exercises, only: [:create, :update, :destroy]

    def index
        @source_files = @exercise.source_files.all
    end

    def show
    end

    def create
        @source_file = @exercise.source_files.create!(@json)

        #TODO source_file.name should be unique 
        if @source_file.valid?
            render action: :show, status: :created, 
                :location => exercise_source_file_path(@exercise, @source_file)
        else
            render json: @source_file.errors.messages, status: :bad_request
        end
    end

    def update
        if not @source_file.update(@json)
            render json: @source_file.errors.messages, status: :bad_request
        end
    end

    def destroy
        if @source_file.destroy
            render nothing: true, status: :no_content
        else
            render nothing: true, status: :internal_server_error
        end
    end

    private

    def get_exercise
        @exercise = Exercise.find(params[:exercise_id])
    end

    def get_source_file
        get_exercise unless @exercise
        @source_file = @exercise.source_files.find(params[:id])
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
