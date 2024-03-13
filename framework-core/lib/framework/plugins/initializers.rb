module Framework
  module Plugins
    module Initializers
      def self.before_load(mod)
        path = mod.root.join("config/initializers")
        return unless path.directory?

        path.children.each do |initializer|
          require initializer
        end
      end
    end
  end
end
