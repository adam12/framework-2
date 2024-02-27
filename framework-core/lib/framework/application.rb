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

    @loaded_plugins = []

    def self.plugin(mod, ...)
      return if @loaded_plugins.include?(mod)
      @loaded_plugins.push(mod)

      mod.before_load(self, ...) if mod.respond_to?(:before_load)

      load_plugin(self, mod)

      mod.after_load(self, ...) if mod.respond_to?(:after_load)
    end

    # Empty hook used for customizing plugin loading
    def self.load_plugin(application, mod)
    end

    def self.inherited(subclass)
      super

      subclass.class_eval do
        @loaded_plugins = []
      end
    end

    def self.root
      @root ||= find_root
    end

    def self.find_root
      Pathname.new(Dir.pwd).ascend do |dir|
        path = File.expand_path("Gemfile", dir)
        return dir if File.exist?(path)
      end
    end

    plugin(Framework::Plugins::Core)
  end
end
