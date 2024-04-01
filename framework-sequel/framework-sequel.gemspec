require_relative "../framework-core/lib/framework/version"

Gem::Specification.new do |spec|
  spec.name = "framework-sequel"
  spec.version = Framework::VERSION
  spec.summary = "Sequel adapter for framework"

  spec.author = "Adam Daniels"

  spec.files = Dir.glob("lib/**/*.rb")

  spec.add_dependency "sequel", "~> 5.77"

  spec.required_ruby_version = ">= 3.1.0"
end
