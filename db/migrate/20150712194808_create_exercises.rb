class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :title
      t.string :kind
      t.integer :difficulty
      t.text :description

      t.timestamps null: false
    end
  end
end
