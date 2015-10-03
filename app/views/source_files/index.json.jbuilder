@source_files.each do |source_file|
  json.set! source_file.name do
  	json.partial! source_file
  	json._url exercise_source_file_url(source_file.exercise_id, source_file, format: :json)
  end  
end
