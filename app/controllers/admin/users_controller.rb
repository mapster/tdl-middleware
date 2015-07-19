class Admin::UsersController < UsersController 
    before_filter :authorized_to_manage_users
    before_filter :get_user, only: [:show, :update, :destroy]

    def index
        render json: User.all
    end

    private
    def get_user
        @user = User.find(params[:id])
    end

    def authorized_to_manage_users
        render nothing: true, status: :not_found unless authorized? :manage_users
    end
end
