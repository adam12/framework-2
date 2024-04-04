# frozen-string-literal: true

module Framework
  class Application
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

    plugin(Framework::Plugins::Core)
  end
end
