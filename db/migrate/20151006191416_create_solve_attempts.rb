class CreateSolveAttempts < ActiveRecord::Migration
  def change
    create_table :solve_attempts do |t|
      t.references :solution, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
