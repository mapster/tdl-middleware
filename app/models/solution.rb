class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  has_many :solve_attempts, dependent: :destroy
  has_many :source_files, :as => :source_set, dependent: :destroy
end
