class SolveAttemptsController < ApplicationController
  before_filter :authorize_by_authentication
  before_filter :get_solution
  
  def index
    @solve_attempts = SolveAttempt.where(solution_id: @solution.id)
  end
  
  def show
    @solve_attempt = SolveAttempt.find_by(id: params[:id], solution_id: @solution.id)
    if @solve_attempt.nil?
      render nothing: true, status: :not_found and return
    end
  end
  
  private
    
  def get_solution
   @solution = Solution.find_by(user_id: current_user.id, exercise_id: params[:solution_id])
  end
end
