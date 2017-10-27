class SourceFile < ActiveRecord::Base
  belongs_to :source_set, :polymorphic => true
  validates :name, presence: true
  validates :contents, presence: true
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
    return exercise.id unless exercise.nil?
    nil
  end
  
  def exercise
    if source_set_type == "Exercise"
      source_set        
    elsif source_set_type == "Solution"
      source_set.exercise        
    else
      nil
    end
  end

end