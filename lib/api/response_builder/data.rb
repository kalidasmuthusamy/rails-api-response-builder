# frozen_string_literal: true
module ResponseBuilder
  # Class which helps in building api response body
  class Data < Base
    attr_accessor :data

    def initialize(resource, config = {})
      super(resource, config)
      @data = nil
      set_data
    end

    private

    def set_data
      return if exception?
      set_object_data
      set_collection_data
    end

    def set_collection_data
      return unless collection?
      @data = ActiveModel::Serializer::CollectionSerializer.
        new(resource, config)
    end

    def set_object_data
      return if invalid_resource?
      serializer = config[:serializer]
      @data = serializer ? serializer.new(resource, config) : resource
    end
  end
end
