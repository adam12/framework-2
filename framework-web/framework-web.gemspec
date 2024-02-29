require_relative "../framework-core/lib/framework/version"

Gem::Specification.new do |spec|
  spec.name = "framework-web"
  spec.version = Framework::VERSION
  spec.summary = "Web for framework"

  spec.author = "Adam Daniels"

  spec.files = Dir.glob("lib/**/*.rb")

  spec.add_dependency "hanami-router", "~> 2.0"
  spec.add_dependency "rack", ">= 2.0"
end
