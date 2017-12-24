# frozen_string_literal: true
module Api
  module ResponseBuilder
    # Class which helps in building messges for api response
    class Messages < ::Api::ResponseBuilder::Base
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
        exception = ::Api::Exception.internal_server_error
        @messages[:errors] = ::Api::Exception.new(exception, resource.message).
          full_messages
      end

      def add_errors_if_any
        @messages[:errors] = resource.full_messages if api_exception?
        return unless resource_has_errors?
        @messages[:errors] = resource.errors.full_messages
      end
    end
  end
end
