module Framework
  module Plugins
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
