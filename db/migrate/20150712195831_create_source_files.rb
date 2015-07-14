class CreateSourceFiles < ActiveRecord::Migration
  def change
    create_table :source_files do |t|
      t.string :name
      t.text :contents
      t.references :exercise, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
