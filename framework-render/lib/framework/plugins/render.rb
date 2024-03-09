# frozen-string-literal: true

module Framework
  module Plugins
    module Render
      def self.before_load(application, template_opts: {})
        require "tilt"
        require "framework-web"

        application.plugin Framework::Plugins::Http
        application::Action.include(ActionMethods)

        yield if defined?(yield)
      end

      module ActionMethods
        def render(template, layout: nil, locals: {}, **local_args)
          if local_args.any?
            warn <<~MSG, uplevel: 1, category: :deprecated
              Passing bare locals to `render` is deprecated. Use `locals:` key instead.
            MSG
          end

          locals = locals.merge(local_args)
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
