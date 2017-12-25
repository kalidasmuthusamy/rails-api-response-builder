# Api::ResponseBuilder

Module to build response object for Rails 5 API Applications.
Depends on `active_model_serializers` gem.

Pass a valid / invalid ActiveRecord object or an instance of ActiveRecord::Relation and get response object in following structure.

Properties | Description
------------ | -------------
status | 'failure' (or) 'success'
body | Serialized Object
messages | Error Description (if any)
status_code | HTTP Status Code


## Example

```ruby
#app/controllers/api/v1/application_controller.rb
module Api
  module V1
    class ApplicationController < ActionController::API

      def serializer_responder(resource, config = {})
        response = ::Api::ResponseBuilder::Main.new(resource, config, params).response
        render json: response, status: response[:status_code]
      end

    end
  end
end

# app/serializers/v1/user_serializer.rb
module V1
  # Serializer for User model
  class UserSerializer < ::ActiveModel::Serializer
    attributes :id,
      :firstname,
      :lastname,
      :phone_number,
      :email
  end
end


# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    # Defines endpoints for CRUD operations on user model
    class UsersController < ::Api::V1::ApplicationController

      def index
        users = User.all
        serializer_responder(users, serializer: ::V1::UserSerializer)
      end

    end
  end
end

```

Response Object for API endpoint `/api/v1/users` will be

```json
{
  "status": "success", 
  "body" :  
    [
      {
        "id": 1,
        "firstname": "Kalidas",
        "lastname": "M",
        "phone_number": "+919876543210",
        "email": "kalidasm610@gmail.com"
      },
      {
        "id": 2,
        "firstname": "Dass",
        "lastname": "Mk",
        "phone_number": "+919876543211",
        "email": ""
      }
    ],
  "status_code": "ok"
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api-response_builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api-response_builder

## Usage

#### ApplicationController - Setup
By taking advantage of Ruby's inheritance and Rails's app structure, few instance methods in application controller can be used to handle all scenarios for rendering json response across entire application.

```ruby
  module Api
    module V1
      class ApplicationController < ActionController::API
        # action callbacks

        # Global Exception Handler for Api Exceptions and StandardError
        rescue_from ::Api::Exception, StandardError do |e|
          handle_api_exception(e)
        end

        # Global exception handlers for ActiveRecord Exceptions
        rescue_from ::ActiveRecord::RecordNotFound, with: :render_record_not_found
        rescue_from ::ActiveRecord::RecordInvalid, with: :render_record_invalid
        rescue_from ::ActiveRecord::RecordNotDestroyed, with: :render_forbidden

        # Public methods
        def handle_api_exception(e)
          response = ::Api::ResponseBuilder::Main.new(e, {}, params).response
          render json: response, status: response[:status_code]
        end

        def render_record_not_found
          handle_api_exception ::Api::Exception.new(
            ::Api::Exception.record_not_found
          )
        end

        def render_internal_server_error
          handle_api_exception ::Api::Exception.new(
            ::Api::Exception.internal_server_error
          )
        end

        def render_record_invalid(e)
          # If exception message is not included in arguments, locale message
          # (if present) for record invalid exception will be returned in resp
          exception_message = e.record.errors.full_messages
          exception = ::Api::Exception.new(
            ::Api::Exception.record_invalid, exception_message
          )
          handle_api_exception(exception)
        end

        def render_forbidden
          handle_api_exception ::Api::Exception.new(
            ::Api::Exception.forbidden_resource
          )
        end

        def serializer_responder(resource, config = {})
          response = ::Api::ResponseBuilder::Main.new(resource, config, params).response
          # response object also contains corresponding http status code under the key :status_code
          # Including `Http Status Code` as part of API response is generally considered as good practice
          # If all your api responses should have `200 OK` as status code, omit status key in render method
          # Rails, by default, set status code as `200 OK`
          render json: response, status: response[:status_code]
        end
      end
    end
  end

```

#### Api Exceptions

Following exceptions are handled by this gem as there are the most commonly used.

EXCEPTION | HTTP Status Code
------------ | -------------
INTERNAL_SERVER_ERROR | :internal_server_error (500)
RECORD_NOT_FOUND | :not_found (404)
RECORD_INVALID | ::unprocessable_entity (422)
RECORD_NOT_DESTROYED | :forbidden (403)
FORBIDDEN_RESOURCE | :forbidden (403)
UNAUTHORIZED_ACCESS | :unauthorized (401)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kalidasm/api-response_builder.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
