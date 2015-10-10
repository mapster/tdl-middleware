json.array!(@solve_attempts) do |solve_attempt|
  json.partial! solve_attempt
  #json._url exercise_url(exercise, format: :json)
end
