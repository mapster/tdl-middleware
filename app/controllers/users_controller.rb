class UsersController < ResourceBaseController 
    MODIFIABLE = ["name", "email", "password", "password_confirmation"]
    REQUIRED = MODIFIABLE

    before_filter :authorize_by_authentication, only: [:show, :update, :destroy]
    before_filter :get_user, only: [:show, :update, :destroy]

    # reassign payload validation filters
    skip_before_filter :has_required_fields, only: [:update]
    before_filter :has_update_required_fields, only: [:update]

    def create
        user = User.new(@json)

        if user.valid? and user.save
            @user = user
        else
            render json: user.errors.messages, status: :bad_request
        end
        # render nothing: true, status: :forbidden
    end

    def update
        if @user.nil?
            render nothing: true, status: :not_found
        elsif not @user.update(@json)
            render json: @user.errors.messages, status: :bad_request
        end
        # render nothing: true, status: :not_found
    end

    def destroy
            # render nothing: true, status: :not_found and return
        if @user.nil?
            render nothing: true, status: :not_found        
        elsif @user.destroy
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

    def modifiable
        MODIFIABLE
    end

    def required
        REQUIRED
    end

end
