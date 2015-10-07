class SourceFile < ActiveRecord::Base
  belongs_to :source_set, :polymorphic => true
  validates :name, presence: true
  validates :source_set, presence: true
  
  def initialize(args)
      if args["exercise_id"]
          args["source_set_id"] = args["exercise_id"]
          args["source_set_type"] = "Exercise"
          args.delete "exercise_id"
      end
      super args
  end
  
  def exercise_id
      return nil unless source_set_type == "Exercise"
      source_set_id
  end
  
  def exercise
      return nil unless source_set_type == "Exercise"
      source_set
  end
end
