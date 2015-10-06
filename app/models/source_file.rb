class SourceFile < ActiveRecord::Base
  belongs_to :source_set, :polymorphic => true
  validates :name, presence: true
  validates :source_set, presence: true
end
