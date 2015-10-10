class SolveAttemptsController < ApplicationController
  before_filter :authorize_by_authentication
  before_filter :get_solution
  
  def index
    @solve_attempts = SolveAttempt.where(solution_id: @solution.id)
  end
  
  private
    
  def get_solution
   @solution = Solution.find_by(user_id: current_user.id, exercise_id: params[:solution_id])
  end
end
