@solutions.each do |solution|
  json.set! solution.exercise_id do
  	json.partial! solution
  	#json._url exercise_url(exercise, format: :json)
  end
end
