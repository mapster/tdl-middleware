class ChangeSourceFileToPolymorphic < ActiveRecord::Migration
  def change
    change_table :source_files do |t|
      t.references :source_set, polymorphic: true, index: true
      t.remove_references :exercise
    end 
  end
end
