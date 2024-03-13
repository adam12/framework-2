# frozen-string-literal: true

module Framework
  module Plugins
    module H
      def self.before_load(mod)
        require "cgi/util"

        mod::Action.include(ActionMethods)
      end

      module ActionMethods
        def h(str)
          return if str.nil?
          CGI.escapeHTML(str)
        end
      end
    end
  end
end
