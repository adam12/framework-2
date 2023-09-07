require_relative "lib/framework/version"

Gem::Specification.new do |spec|
  spec.name = "framework-core"
  spec.version = Framework::VERSION
  spec.summary = "Core for framework"

  spec.author = "Adam Daniels"

  # spec.bindir = "exe"
  # spec.executables = ["framework"]
  spec.files = Dir.glob("lib/**/*.rb")

  spec.add_dependency "dry-configurable", ">= 0.12.0"
  spec.add_dependency "hanami-router", "~> 2.0"
  spec.add_dependency "rack", ">= 2.0"
  spec.add_dependency "variant", "~> 0.1"
end
