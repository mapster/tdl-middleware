class SolveAttemptsController < ResourceBaseController
  REQUIRED = ["source_files"]
  MODIFIABLE = REQUIRED
  
  before_filter :authorize_by_authentication
  before_filter :get_solution
  
  attr_accessor :jcoru_proxy
  
  def initialize
    @jcoru_proxy = JcoruProxy.new
  end
  
  def index
    @solve_attempts = SolveAttempt.where(solution_id: @solution.id).order(created_at: :desc).limit(10).reverse
  end
  
  def show
    @solve_attempt = SolveAttempt.find_by(id: params[:id], solution_id: @solution.id)
    if @solve_attempt.nil?
      render nothing: true, status: :not_found and return
    end
  end
  
  def create
    @solve_attempt = SolveAttempt.new(solution: @solution)
    if @solve_attempt.invalid?
      render json: @solve_attempt.errors.messages, status: :bad_request and return
    else
      source_files = @json['source_files'].map do |sf| 
        source_file = SourceFile.new sf
        source_file.source_set = @solve_attempt
        source_file
      end
      
      if source_files.any? { |sf| sf.invalid? }
        errors = source_files.map {|sf| sf.errors.messages}
        render json: {:source_files => errors}, status: :bad_request and return
        
      elsif @solution.exercise.source_files.any? {|sf| source_files.any? {|override| sf.name == override.name}}
        render json: {:source_files => "Not allowed to override exercise sources"}, status: :bad_request and return 
        
      else 
        @solve_attempt.report = @jcoru_proxy.run_junit(@solution.exercise.source_files | source_files)
        check_report
        
        @solve_attempt.save!
        source_files.each {|sf| sf.save}
        
        render action: :show, status: :created, :location => users_solution_solve_attempt_path(@solution.exercise_id, @solve_attempt.id)
      end
    end
  end
  
  private
    
  #the :solution_id param of this controller actually refers to exercise id
  def get_solution
    @solution = Solution.find_by(user_id: current_user.id, exercise_id: params[:solution_id])
    if @solution.nil?
      render nothing: true, status: :not_found and return
    end  
  end
  
  def required
    REQUIRED
  end
  
  def modifiable
    MODIFIABLE
  end
  
  def check_report
    report = @solve_attempt.report
    if report["server_error"]
      logger.error "Failed to run junit tests for solve_attempt #{@solve_attempt.id}: #{@solve_attempt.report}"
    elsif report["compilationReport"].nil? && report["junitReport"].nil?
      logger.error "Unknown junit test result type: #{@solve_attempt.report}"
    end             
  end
end
