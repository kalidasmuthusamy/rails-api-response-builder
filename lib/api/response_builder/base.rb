# frozen_string_literal: true
module Api
  module ResponseBuilder
    # Base Class for building api response
    class Base
      attr_accessor :resource,
        :config

      def initialize(resource, config = {})
        @resource = resource
        @config = config
      end

      protected

      def active_model_object?
        @resource.is_a?(ActiveRecord::Base)
      end

      def hash_object?
        @resource.is_a?(Hash)
      end

      def resource_has_errors?
        active_model_object? && @resource.errors.any?
      end

      def collection?
        @resource.is_a?(ActiveRecord::Relation) || @resource.is_a?(Array)
      end

      def exception?
        @resource.is_a?(Exception)
      end

      def other_exception?
        !api_exception? && @resource.is_a?(StandardError)
      end

      def api_exception?
        @resource.is_a?(ApiException)
      end

      def invalid_resource?
        return @resource.errors.any? if active_model_object?
        false
      end
    end
  end
end
