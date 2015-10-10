class SolveAttempt < ActiveRecord::Base
  belongs_to :solution
  has_many :source_files, :as => :source_set, dependent: :destroy
end
