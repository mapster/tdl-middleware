class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  has_many :solve_attempts, dependent: :destroy
end
