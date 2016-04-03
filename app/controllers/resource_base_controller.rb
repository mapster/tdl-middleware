class ResourceBaseController < ApplicationController
  before_filter :parse_request, only: [:create, :update]
  before_filter :is_json_object, only: [:create, :update]
  before_filter :only_modifiable_fields, only: [:create, :update]
  before_filter :has_required_fields, only: [:create, :update]

  private

  def modifiable
    []
  end

  def required
    []
  end

  def only_modifiable_fields
    has_only_entries @json.keys, modifiable, "Field not modifiable."
  end

  def has_required_fields
    has_only_entries required, @json.keys, "Required field missing."
  end

  def has_only_entries list, entries, message
    extra_entries = list - entries 
    if not extra_entries.empty?
      render json: Hash[extra_entries.map {|f| [f, message]}], status: :bad_request
    end
  end
  
  def is_json_object
    render plain: "Payload is not a json object", status: :bad_request unless @json.is_a? Hash
  end

  def parse_request
    @json = JSON.parse(request.body.read)
  end
end
