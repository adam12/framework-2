require_relative "../framework-core/lib/framework/version"

Gem::Specification.new do |spec|
  spec.name = "framework-web"
  spec.version = Framework::VERSION
  spec.summary = "Web for framework"

  spec.author = "Adam Daniels"

  spec.files = Dir.glob("lib/**/*.rb")

  spec.add_dependency "hanami-router", "~> 2.0"
  spec.add_dependency "rack", ">= 2.0"

  # Transitive dependency fix for rack 2.x
  spec.add_dependency "base64", "~> 0.2"

  spec.required_ruby_version = ">= 3.1.0"
end
