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
        application.class_eval do
          plugin Variant

          enable_eager_loading = !application.variant.development? && !application.variant.testing?

          setting :loader do
            setting :eager_load, default: enable_eager_loading
          end

          include ApplicationInstanceMethods
        end

        enable_reloading = application.variant.development?

        require "zeitwerk"

        loader = Zeitwerk::Loader.new
        loader.log! if log

        loader.enable_reloading if enable_reloading

        loader.push_dir(File.join(Dir.pwd, "lib"))

        block&.call(loader)

        loader.setup

        application.const_set(:Loader, loader)
      end

      module ApplicationInstanceMethods
        def after_initialize
          if config.loader.eager_load
            Framework.logger.debug { "Performing eager-load" }
            self.class::Loader.eager_load
          end

          super
        end
      end
    end
  end
end
