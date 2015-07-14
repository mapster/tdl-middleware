class SourceFile < ActiveRecord::Base
  belongs_to :exercise
  validates :name, presence: true
end
