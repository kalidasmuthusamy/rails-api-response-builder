# frozen_string_literal: true
module ResponseBuilder
  # Class which helps in building status of api response
  class Status < Base
    attr_accessor :status_message

    def initialize(resource, config = {})
      super(resource, config)
      @status_message = { status: "success" }
      set_status_message
    end

    private

    def set_status_message
      return unless resource_has_errors? || api_exception? || other_exception?
      @status_message[:status] = "failure"
    end
  end
end
