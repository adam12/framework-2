module Framework
  module Plugins
    module Sequel
      def self.before_load(_application)
        require "sequel"

        begin
          require Bundler.root.join("config/database.rb")
        rescue LoadError => ex
          raise unless ex.message.end_with?("config/database.rb")

          abort <<~EOM
            ERROR: Unable to find config/database.rb at the application root.
          EOM

          # TODO: Copy example file over and tell user?
        end
      end
    end
  end
end
