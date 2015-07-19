class UserSessionsController < ResourceBaseController
    MODIFIABLE = ["email", "password"]
    REQUIRED = MODIFIABLE

    def show 
        if current_user
            render json: current_user
        else
            render nothing: true, status: :not_found
        end
    end

    def create
        @user_session = UserSession.new @json
        if @user_session.save
            render json: current_user
        else
            render nothing: true, status: :not_found
        end
    end

    def destroy
        if current_user_session
            current_user_session.destroy
            render nothing: true, status: :no_content
        else
            render nothing: true, status: :not_found
        end
    end

    private
    def modifiable
        MODIFIABLE
    end

    def required
        REQUIRED
    end
end
