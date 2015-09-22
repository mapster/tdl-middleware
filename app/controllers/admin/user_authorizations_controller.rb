class Admin::UserAuthorizationsController < ResourceBaseController
    MODIFIABLE =  ['manage_exercises','manage_users','manage_authorizations']
    REQUIRED = MODIFIABLE

    before_filter :authorized_to_manage_authorizations
    before_filter :get_auth

    def show
        render nothing: true, status: :not_found and return if @auth.nil?
        render json: @auth
    end

    def update
        new_auth = UserAuthorization.new @json
        new_auth.user_id = params[:user_id]

        if new_auth.valid?
            @auth.destroy if @auth

            new_auth.save
            render json: new_auth
        else
            render json: new_auth.errors.messages, status: :bad_request
        end
    end

    def destroy
        if @auth.destroy
            render nothing: true, status: :no_content
        else
            render nothing: true, status: :internal_server_error
        end
    end

    private
    def get_auth
        @auth = User.find(params[:user_id]).user_authorization
    end

    def authorized_to_manage_authorizations
        render nothing: true, status: :not_found unless authorized? :manage_authorizations
    end 

    def modifiable
        MODIFIABLE
    end

    def required
        REQUIRED
    end

end
