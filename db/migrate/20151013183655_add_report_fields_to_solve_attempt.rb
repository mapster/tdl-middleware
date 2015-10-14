class AddReportFieldsToSolveAttempt < ActiveRecord::Migration
  def change
    add_column :solve_attempts, :report, :text
  end
end
