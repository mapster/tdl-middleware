class UserAuthorizationsController < ResourceBaseController
  before_filter :authorize_by_authentication
  
  def show
    user = current_user
    if user.nil? || user.user_authorization.nil?
      render nothing: true, status: :not_found 
    else 
      @auth = user.user_authorization
    end
  end  
end