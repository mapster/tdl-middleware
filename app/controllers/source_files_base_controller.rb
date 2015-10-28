class SourceFilesBaseController < ResourceBaseController
    MODIFIABLE = ["name", "contents"]
    REQUIRED = MODIFIABLE
    
    before_filter :authorize_by_authentication
    before_filter :get_source_set, only: [:index, :show, :create, :update, :destroy]
    before_filter :existing_source_set, only: [:show, :update, :destroy]
    before_filter :get_source_file, only: [:show, :update, :destroy]
    before_filter :existing_source_file, only: [:show, :update, :destroy]
  
    def index
        @source_files = @source_set.source_files.all
    end

    def create
        @source_file = @source_set.source_files.create!(@json)

        #TODO source_file.name should be unique 
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