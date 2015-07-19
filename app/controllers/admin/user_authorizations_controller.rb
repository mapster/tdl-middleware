class Admin::UserAuthorizationsController < ResourceBaseController
    MODIFIABLE =  ['manage_exercises','manage_users','manage_authorizations']
    REQUIRED = MODIFIABLE

    before_filter :authorized_to_manage_authorizations
    before_filter :get_auth, only: [:show, :destroy]

    def show
        render nothing: true, status: :not_found and return if @auth.nil?
        render json: @auth
    end

    def create
        #TODO Needs to delete old if it exists
        @auth = UserAuthorization.new @json
        @auth.user_id = params[:user_id]

        if @auth.valid? and @auth.save
            render json: @auth
        else
            render json: @auth.errors.messages, status: :bad_request
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
