# frozen-string-literal: true

module Framework
  module Plugins
    module Render
      HTML_EXT = /\.html\b/

      def self.before_load(application, template_opts: {})
        require "tilt"

        if defined?(application::Action)
          application::Action.include(ActionMethods)
        end

        yield if defined?(yield)
      end

      module ActionMethods
        def render(template = nil, content: nil, layout: nil, format: UNDEFINED, locals: {})
          if template && content
            raise ArgumentError, "Passing template and :content is ambiguous"
          end

          case format
          when UNDEFINED
            # Try to guess
            if template.to_s.match?(HTML_EXT)
              response.header["content-type"] = "text/html"
            end
          when nil
            # Do nothing
          when :html
            response.header["content-type"] = "text/html"
          when :json
            response.header["content-type"] = "application/json"
          else
            raise ArgumentError, "Unknown format: #{format.inspect}"
          end

          if layout
            if String === content
              return Tilt.new(layout).render(self) { content }
            end

            Tilt.new(layout).render(self) { Tilt.new(template).render(self, locals) }
          else
            if String === content
              return content
            end

            Tilt.new(template).render(self, locals)
          end
        end
      end
    end
  end
end
