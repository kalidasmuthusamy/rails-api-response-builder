# frozen_string_literal: true
module ResponseBuilder
  # Class which helps in building messges for api response
  class Messages < Base
    attr_accessor :messages

    def initialize(resource, config = {})
      super(resource, config)
      @messages = {}
      set_messages
    end

    private

    def set_messages
      add_errors_if_any
      return unless other_exception?
      exception = ApiException.internal_server_error
      @messages[:errors] = ApiException.new(exception, resource.message).
        full_messages
    end

    def add_errors_if_any
      @messages[:errors] = resource.full_messages if api_exception?
      return unless resource_has_errors?
      @messages[:errors] = resource.errors.full_messages
    end
  end
end
