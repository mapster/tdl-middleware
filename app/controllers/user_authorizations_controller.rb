class UserAuthorizationsController < ResourceBaseController
  before_filter :get_auth
  
#  def show
#    @auth = current_user.auth
#    if @auth
#      render 
#    end
#  end  
  private
  def get_auth
    @auth = current_user.user_authorization
  end
end