class UsersController < ResourceBaseController 
    @@modifiable = ["name", "email", "password", "password_confirmation"]
    @@required = @@modifiable

    before_filter :authorize_by_authentication, only: [:show, :update, :destroy]
    before_filter :get_user, only: [:show, :update, :destroy]

    # reassign payload validation filters
    skip_before_filter :has_required_fields, only: [:update]
    before_filter :has_update_required_fields, only: [:update]

    # should be removed
    def index
        render json: User.all
    end

    def show
        render json: @user
    end

    def create
        @user = User.new(@json)

        if @user.valid? and @user.save
            render json: @user
        else
            render json: @user.errors.messages, status: :conflict
        end
    end

    def update
        if @user.update(@json)
            render json: @user
        else
            render json: @user.errors.messages, status: :bad_request
        end
    end

    def destroy
        if @user.destroy
            render nothing: true, status: :no_content
        else
            render nothing: true, status: :internal_server_error
        end
    end

    private
    def get_user
        @user = current_user
    end

    def has_update_required_fields
        has_only_entries ["name", "email"], @json.keys, "Required field missing."
    end

end
