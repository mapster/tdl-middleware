json.extract! source_file, :id, :name, :contents, :created_at, :updated_at
type = source_file.source_set_type.underscore
json.set! "#{type}_id".to_sym, source_file.source_set_id
json.set! :exercise_id, source_file.exercise_id if type == "solution" 
