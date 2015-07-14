class ResourceBaseController < ApplicationController
    @@modifiable = []
    @@required = @@modifiable

    before_filter :parse_request, only: [:create, :update]
    before_filter :only_modifiable_fields, only: [:create, :update]
    before_filter :has_required_fields, only: [:create, :update]

    private

    def only_modifiable_fields
        non_modifiable = @json.keys - @@modifiable
        unless non_modifiable.empty?
            render json: Hash[non_modifiable.map {|f| [f, "Field not modifiable"]}],  status: :bad_request
        end
    end

    def has_required_fields
        missing_required = @@required - @json.keys
        unless missing_required.empty?
            render json: Hash[missing_required.map {|f| [f, "Required field missing."]}],  status: :bad_request
        end
    end

    def parse_request
        @json = JSON.parse(request.body.read)
    end
end
