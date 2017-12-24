# frozen_string_literal: true
# Base API exception class to create custom exceptions dynamically
# with a code and message passed
require 'i18n'

module Api
  class Exception < ::StandardError
    attr_accessor :messages

    def initialize(error_constant, messages = nil)
      @error_constant = error_constant
      @messages = {
        @error_constant[:key].to_s => [messages || @error_constant[:message]]
      }
    end

    def full_messages
      @messages.values.flatten
    end

    class << self
      def error_constants
        {
          INTERNAL_SERVER_ERROR: {
            message: t(:internal_server_error),
            key: :internal_server_error
          },
          RECORD_NOT_FOUND: {
            message: t(:record_not_found),
            key: :record_not_found
          },
          RECORD_INVALID: {
            message: t(:record_invalid),
            key: :record_invalid
          },
          RECORD_NOT_DESTROYED: {
            message: t(:record_not_destroyed),
            key: :record_not_destroyed
          },
          FORBIDDEN_RESOURCE: {
            message: t(:forbidden_resource),
            key: :forbidden_resource
          },
          UNAUTHORIZED_ACCESS: {
            message: t(:unauthorized_access),
            key: :unauthorized_access
          }
        }
      end

      private

      def t(key)
        ::I18n.config.available_locales = :en
        ::I18n.t("api_response.messages.#{key}")
      end
    end

    error_constants.each do |key, value|
      define_singleton_method(key.downcase) { value }
    end
  end
end
