# frozen_string_literal: true
module Api
  module ResponseBuilder
    # Class which helps in building status code of api response
    class StatusCode < ::Api::ResponseBuilder::Base
      attr_accessor :status_code,
        :resource

      def initialize(resource, config = {})
        super(resource, config)
        @resource = resource
        @status_code = :ok
        set_status_code
      end

      private

      def set_status_code
        return unless resource_has_errors? || api_exception? || other_exception?
        if resource_has_errors?
          @status_code = :unprocessable_entity
        elsif api_exception?
          # resource is an instance of ApiException class
          @status_code = @resource.status_code
        else
          # other exception which is probably internal server error
          @status_code = :internal_server_error
        end
      end
    end
  end
end
