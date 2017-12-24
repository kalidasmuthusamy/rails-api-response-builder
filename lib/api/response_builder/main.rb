# frozen_string_literal: true
module Api
  module ResponseBuilder
    # Class which helps in building whole api response
    class Main
      attr_accessor :resource,
        :config,
        :response,
        :params

      def initialize(resource, config = {}, params = {})
        @resource = resource
        @config = config
        @response = {}
        @params = params
        set_response
      end

      def set_response
        prepare_response
        response_data = ::Api::ResponseBuilder::Data.new(resource, config).data
        messages = ::Api::ResponseBuilder::Messages.new(resource, config).messages

        @response[:body] = response_data if response_data.present?
        @response[:messages] = messages if messages.present?
        return unless config[:count].present?
        @response[:meta] = { total_count: config[:count] }
        @response[:meta].merge!(config[:meta].to_h)
      end

      def prepare_response
        status_msg = ::Api::ResponseBuilder::Status.new(resource, config).status_message
        @response = status_msg.present? ? status_msg : {}
      end
    end
  end
end
