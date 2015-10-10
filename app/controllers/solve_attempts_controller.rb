class SolveAttemptsController < ResourceBaseController 
  REQUIRED = ["source_files"]
  MODIFIABLE = REQUIRED
  
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
  
  def create
    @solve_attempt = SolveAttempt.create
    if @solve_attempt.valid?
      source_files = @json['source_files'].map do |sf| 
        source_file = SourceFile.new sf
        source_file.source_set = @solve_attempt
        source_file
      end
      if source_files.any? { |sf| sf.invalid? }
        @solve_attempt.destroy
        errors = source_files.map {|sf| sf.errors.messages}
        render json: {:source_files => errors}, status: :bad_request
      else 
        source_files.each {|sf| sf.save!}
        render action: :show, status: :created, :location => users_solution_solve_attempt_path(@solution.exercise_id, @solve_attempt.id)
      end
    else
      render json: @solve_attempt.errors.messages, status: :bad_request
    end
    
  end
  
  private
    
  def get_solution
   @solution = Solution.find_by(user_id: current_user.id, exercise_id: params[:solution_id])
  end
  
  def required
    REQUIRED
  end
  
  def modifiable
    MODIFIABLE
  end
end
