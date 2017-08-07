class SourceFilesBaseController < ResourceBaseController
    MODIFIABLE = ["name", "contents"]
    REQUIRED = MODIFIABLE
    
    before_filter :authorize_by_authentication
    before_filter :get_source_set, only: [:index, :show, :create, :update, :destroy]
    before_filter :existing_source_set, only: [:index, :show, :create, :update, :destroy]
    before_filter :get_source_file, only: [:show, :update, :destroy]
    before_filter :existing_source_file, only: [:show, :update, :destroy]
    before_filter :unique_name, only: [:create, :update]
  
    def index
        @source_files = @source_set.source_files.all
    end

    def create
        @source_file = @source_set.source_files.create!(@json)

        if @source_file.valid?
            render action: :show, status: :created, 
                :location => source_file_path
        else
            render json: @source_file.errors.messages, status: :bad_request
        end
    end
    
    def update
        if not @source_file.update(@json)
            render json: @source_file.errors.messages, status: :bad_request
        end
    end
    
    def destroy
        if @source_file.destroy
            render nothing: true, status: :no_content
        else
            render nothing: true, status: :internal_server_error
        end
    end
    
    private 
    
    def unique_name
        sf = SourceFile.new @json
        existing = @source_set.source_files.find_by(name: sf.name) 
        # Verify that there either not exists any file with the name, or that if it does it is the same file (i.e. update)
        if existing && (@source_file.nil? || existing.id != @source_file.id) 
          render plain: "Duplicate name: a source file with name #{sf.name} already exists", status: :conflict and return
        end
    end
    
    def existing_source_set
        if @source_set.nil?
            render nothing: true, status: :not_found and return
        end   
    end
    
    def existing_source_file
        if @source_file.nil?
            render nothing: true, status: :not_found and return
        end   
    end
end 