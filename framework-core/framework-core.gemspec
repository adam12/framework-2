require_relative "lib/framework/version"

Gem::Specification.new do |spec|
  spec.name = "framework-core"
  spec.version = Framework::VERSION
  spec.summary = "Core for framework"

  spec.author = "Adam Daniels"

  # spec.bindir = "exe"
  # spec.executables = ["framework"]
  spec.files = Dir.glob("lib/**/*.rb")

  spec.add_dependency "bake", "~> 0.19"
  spec.add_dependency "console", "~> 1.0"
  spec.add_dependency "dotenv", "~> 3.0"
  spec.add_dependency "variant", "~> 0.1"
  spec.add_dependency "zeitwerk", "~> 2.6"

  spec.required_ruby_version = ">= 3.1.0"
end
