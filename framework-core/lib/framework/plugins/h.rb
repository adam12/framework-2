# frozen-string-literal: true

module Framework
  module Plugins
    module H
      def self.before_load(_mod)
        require "cgi/util"
      end

      module ActionMethods
        def h(str)
          CGI.escapeHTML(str)
        end
      end
    end
  end
end
