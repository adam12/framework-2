# frozen-string-literal: true

module Framework
  module Plugins
    module Render
      HTML_EXT = /\.html\b/

      def self.before_load(application, options = {})
        require "tilt"

        begin
          require "erubi/capture_block"
          options[:engine_options] ||= {}

          # Default erb engine to CaptureBlock with escape enabled
          options[:engine_options]["erb"] = {
            engine_class: ::Erubi::CaptureBlockEngine,
            escape: true
          }.merge(options[:engine_options]["erb"] || {})
        rescue LoadError
          # This is OK
        end

        if defined?(application::Action)
          application::Action.include(RenderMethods)
          application::Action.include(ActionMethods)

          application::Action.define_singleton_method(:render_options) do
            options
          end
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
        def render(template = nil, content: nil, layout: nil, locals: {}, engine: "erb")
          options = self.class.respond_to?(:render_options) ? self.class.render_options : {}
          engine_options = options.dig(:engine_options, engine) || {}

          retrieve_template = proc do |file|
            Tilt[file].new(file, 1, engine_options)
          end

          case {template:, content:, layout:} # standard:disable Lint/LiteralAsCondition
          # Ambiguous params
          in {template: String, content: String}
            raise ArgumentError, "Passing template and :content is ambiguous"

          # Layout with string content
          in {layout: String | Pathname, content: String}
            retrieve_template.call(layout).render(self) { content }

          # Layout with template
          in {template: String | Pathname, content: nil, layout: String | Pathname}
            retrieve_template.call(layout).render(self) { retrieve_template.call(template).render(self, locals) }

          # Inline content without layout
          in {template: nil, content: String, layout: nil}
            content

          # Template without layout
          in {template: String | Pathname, content: nil, layout: nil}
            retrieve_template.call(template).render(self, locals)
          end
        end
      end
    end
  end
end
