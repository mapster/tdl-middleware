@source_files.each do |source_file|
  json.set! source_file.name do
  	json.partial! source_file
  	type = source_file.source_set_type.underscore
  	if type == "exercise"
  		json._url exercise_source_file_url(source_file.exercise_id, source_file, format: :json)
	elsif type == "solution"
  		json._url users_solution_source_file_url(source_file.exercise_id, source_file, format: :json)
	end
  end  
end
