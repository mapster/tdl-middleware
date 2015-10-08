json.array!(@solutions) do |solution|
  json.partial! solution
  #json._url exercise_url(exercise, format: :json)
end
