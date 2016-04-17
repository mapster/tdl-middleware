json.extract! solution, :id, :user_id, :exercise_id, :created_at, :updated_at
json.set! :total_attempts, solution.solve_attempts.size
