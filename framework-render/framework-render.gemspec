require_relative "../framework-core/lib/framework/version"

Gem::Specification.new do |spec|
  spec.name = "framework-render"
  spec.version = Framework::VERSION
  spec.summary = "Render for framework"

  spec.author = "Adam Daniels"

  spec.files = Dir.glob("lib/**/*.rb")

  spec.add_dependency "tilt", "~> 2.0"
end
