
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "api/response_builder/version"

Gem::Specification.new do |spec|
  spec.name          = "api-response_builder"
  spec.version       = Api::ResponseBuilder::VERSION
  spec.authors       = ["Dass Mk"]
  spec.email         = ["kalidasm610@gmail.com"]

  spec.summary       = %q{API Response Builder to keep controllers super-slim}
  spec.description   = %q{Pass the queried objects in controller to this service along with serializer class. It will handle all scenarios, set the data and status code accordingly.}
  spec.homepage      = "https://github.com/kalidasm/rails-api-response-builder"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "i18n", "~> 0.7.0"
end
