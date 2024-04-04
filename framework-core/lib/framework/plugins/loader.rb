# frozen-string-literal: true

module Framework
  module Plugins
    # Automatic loading of application files using Zeitwerk.
    #
    # Enables reloading if running running in development.
    # Enables eager loading if not running in development or testing.
    #
    # Pass `log: true` when loading plugin to enable logging.
    #
    # ## Example
    #   class Application < Framework::Application
    #     plugin Framework::Plugins::Loader
    #   end
    module Loader
      def self.before_load(application, log: false, &block)
        application.plugin Variant

        enable_reloading = application.variant.development?
        # enable_eager_loading = !application.variant.development? && !application.variant.testing?

        require "zeitwerk"

        loader = Zeitwerk::Loader.new
        loader.log! if log

        loader.enable_reloading if enable_reloading

        loader.push_dir(File.join(Dir.pwd, "lib"))

        block&.call(loader)

        loader.setup
        # loader.eager_load if enable_eager_loading

        application.const_set(:Loader, loader)
      end
    end
  end
end
