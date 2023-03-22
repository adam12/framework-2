# frozen-string-literal: true

module Framework
  module Plugins
    module Render
      def self.before_load(application)
        require "tilt"

        application.plugin Framework::Plugins::Http
        application::HttpAction.include(ActionMethods)
      end

      module ActionMethods
        def render(template, layout: nil, **locals)
          if layout
            Tilt.new(layout).render(self) { Tilt.new(template).render(self, locals) }
          else
            Tilt.new(template).render(self, locals)
          end
        end
      end
    end
  end
end
