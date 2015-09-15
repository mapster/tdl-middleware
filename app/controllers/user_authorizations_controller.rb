class UserAuthorizationsController < ResourceBaseController
  
  def show
    @auth = current_user.user_authorization
    if @auth.nil?
      render nothing: true, status: :not_found 
    end
  end  
end