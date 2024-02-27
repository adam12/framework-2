module Framework
  module Plugins
    module Loader
      def self.before_load(application, log: false, &block)
        application.plugin Variant

        require "zeitwerk"

        loader = Zeitwerk::Loader.new
        loader.log! if log

        loader.enable_reloading if application.variant.development?

        loader.push_dir(File.join(Dir.pwd, "lib"))
        block&.call(loader)
        loader.setup
        application.const_set(:Loader, loader)
      end
    end
  end
end
