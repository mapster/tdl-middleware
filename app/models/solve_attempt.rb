class SolveAttempt < ActiveRecord::Base
  belongs_to :solution
  has_many :source_files, :as => :source_set, dependent: :destroy
  
  def report
    r = read_attribute(:report)
    if r.nil?
      nil 
    else
      JSON.parse r
    end
  end

  def status
    if report["server_error"]
      "server_error"
    elsif report["compilationReport"]
      "compilation_error"
    elsif report["junitReport"]
      if report["junitReport"]["failures"].empty?
        "success"
      else
        "junit_failure"
      end
    else
      "unknown"
    end
  end
end
