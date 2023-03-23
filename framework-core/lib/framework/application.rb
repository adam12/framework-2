# frozen-string-literal: true

require_relative "configurable"
require_relative "utils"

module Framework
  class Application
    attr_reader :namespace
    attr_reader :config

    extend Framework::Configurable

    def initialize(namespace, config)
      @namespace = namespace
      @config = config
    end

    def self.namespace
      Utils.deconstantize(to_s)
    end

    def self.plugin(mod, ...)
      mod.before_load(self, ...) if mod.respond_to?(:before_load)

      load_plugin(self, mod)

      mod.after_load(self, ...) if mod.respond_to?(:after_load)
    end

    # Empty hook used for customizing plugin loading
    def self.load_plugin(application, mod)
    end

    plugin(Framework::Plugins::Core)
  end
end
