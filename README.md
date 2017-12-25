# Api::ResponseBuilder

Module to build response object for Rails 5 API Applications.

Pass a valid / invalid ActiveRecord object or an instance of ActiveRecord::Relation and get response object with following properties.
* status (failure / success)
* body
* status_code (http_status_code)
* messages (description of error)

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
  class UserSerializer < ::ApplicationSerializer
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
    class UsersController < ApplicationController

      def index
        users = User.all
        serializer_responder(users, serializer: ::V1::UserSerializer)
      end

    end
  end
end

```

Response for API endpoint `/api/v1/users` will be

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

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/api-response_builder.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
