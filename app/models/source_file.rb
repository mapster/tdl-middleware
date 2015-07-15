class SourceFile < ActiveRecord::Base
  belongs_to :exercise
  validates :name, presence: true
  validates :exercise_id, presence: true
end
