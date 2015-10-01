class GiveAuthorizationsDefaultValue < ActiveRecord::Migration
  def change
      change_column_null :user_authorizations, :manage_exercises, false
      change_column_null :user_authorizations, :manage_users, false
      change_column_null :user_authorizations, :manage_authorizations, false
  end
end
