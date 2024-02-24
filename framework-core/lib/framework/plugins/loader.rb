module Framework
  module Plugins
    module Loader
      def self.before_load(application, log: false, &block)
        require "zeitwerk"

        loader = Zeitwerk::Loader.new
        loader.log! if log
        loader.push_dir(File.join(Dir.pwd, "lib"))
        block&.call(loader)
        loader.setup
        application.const_set(:Loader, loader)
      end
    end
  end
end
