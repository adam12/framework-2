module Framework; VERSION = "0.1.0"; end

Gem::Specification.new do |spec|
  spec.name = "framework-core"
  spec.version = Framework::VERSION
  spec.summary = "Core for framework"

  spec.author = "Adam Daniels"

  # spec.bindir = "exe"
  # spec.executables = ["framework"]
  spec.files = Dir.glob("lib/**/*.rb")

  spec.add_dependency "hanami-router", "2.0.0.alpha5"
  spec.add_dependency "zeitwerk", "~> 2.4"

  spec.add_development_dependency "minitest"
end
