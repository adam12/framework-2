# frozen-string-literal: true

module Framework
  module Plugins
    module Render
      HTML_EXT = /\.html\b/

      def self.before_load(application)
        require "tilt"

        if defined?(application::Action)
          application::Action.include(RenderMethods)
          application::Action.include(ActionMethods)
        end

        yield if defined?(yield)
      end

      module ActionMethods
        def render(template = nil, format: UNDEFINED, **rest)
          res = super(template, **rest)

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

          res
        end
      end

      module RenderMethods
        def render(template = nil, content: nil, layout: nil, locals: {})
          case {template:, content:, layout:}
          # Ambiguous params
          in {template: String, content: String}
            raise ArgumentError, "Passing template and :content is ambiguous"

          # Layout with string content
          in {layout: String, content: String}
            return Tilt.new(layout).render(self) { content }

          # Layout with template
          in {template: String, content: nil, layout: String}
            Tilt.new(layout).render(self) { Tilt.new(template).render(self, locals) }

          # Inline content without layout
          in {template: nil, content: String, layout: nil}
            return content

          # Template without layout
          in {template: String, content: nil, layout: nil}
            Tilt.new(template).render(self, locals)
          end
        end
      end
    end
  end
end
