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
end
