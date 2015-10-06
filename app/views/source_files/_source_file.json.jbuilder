json.extract! source_file, :id, :source_set_id, :name, :contents, :created_at, :updated_at
json.set! "#{source_file.source_set_type.underscore}_id".to_sym, source_file.source_set_id
