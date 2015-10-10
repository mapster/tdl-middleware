class SolutionsController < ResourceBaseController
  before_filter :authorize_by_authentication
  before_filter :get_exercise, only: [:show]
  before_filter :get_solution, only: [:show]
    
  def index
    @solutions = Solution.where(user_id: current_user.id)
  end
    
  def show
    if @solution.nil?
      @solution = Solution.new :user => current_user, :exercise_id => @exercise.id
      if not @solution.save
        render nothing: true, status: :internal_server_error
      end
    end
  end
  
  private
    
  def get_solution
   @solution = Solution.find_by(user_id: current_user.id, exercise_id: params[:id])
  end
    
  def get_exercise
    @exercise = Exercise.find_by_id(params[:id])
    if @exercise.nil?
      render nothing: true, status: :not_found and return
    end
  end
end
