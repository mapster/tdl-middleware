json.extract! solve_attempt, :id, :report, :created_at, :updated_at
json.set! :solution_id, solve_attempt.solution.id
json.set! :exercise_id, solve_attempt.solution.exercise.id