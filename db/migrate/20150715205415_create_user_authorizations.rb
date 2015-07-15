class CreateUserAuthorizations < ActiveRecord::Migration
  def change
    create_table :user_authorizations do |t|
      t.references :user, index: true, foreign_key: true
      t.boolean :manage_exercises
      t.boolean :manage_users
      t.boolean :manage_authorizations

      t.timestamps null: false
    end
  end
end
