json.array!(@exercises) do |exercise|
  json.partial! exercise
  json._url exercise_url(exercise, format: :json)
end
