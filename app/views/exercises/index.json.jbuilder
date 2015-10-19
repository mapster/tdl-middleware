@exercises.each do |exercise|
  json.set! exercise.id do
	  json.partial! exercise
  	json._url exercise_url(exercise, format: :json)
  end
end
