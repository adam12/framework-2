# frozen-string-literal: true

require "hanami/router"
require "framework/utils"
require_relative "resolver"
require_relative "routes"

module Framework
  class Router
    def initialize(router, &blk)
      @router = router
      instance_eval(&blk) if blk
    end

    def self.build(application)
      resolver = Framework::Resolver.new(application)
      route_class = begin
        application.namespace::Routes
      rescue NameError
        # Define empty routes class if none has been defined
        application.namespace.const_set(:Routes, Class.new(Framework::Routes))
      end

      router = Hanami::Router.new(
        base_url: application.settings[:http_router][:base_url],
        resolver: resolver
      )

      new(router, &route_class.routes)
    end

    def get(path, to: nil, as: nil, **constraints, &)
      @router.get(path, to: to, as: as, **constraints, &)
    end

    def post(path, to: nil, as: nil, **constraints, &)
      @router.post(path, to: to, as: as, **constraints, &)
    end

    def patch(path, to: nil, as: nil, **constraints, &)
      @router.patch(path, to: to, as: as, **constraints, &)
    end

    def put(path, to: nil, as: nil, **constraints, &)
      @router.put(path, to: to, as: as, **constraints, &)
    end

    def delete(path, to: nil, as: nil, **constraints, &)
      @router.delete(path, to: to, as: as, **constraints, &)
    end

    def link(path, to: nil, as: nil, **constraints, &)
      @router.link(path, to: to, as: as, **constraints, &)
    end

    def unlink(path, to: nil, as: nil, **constraints, &)
      @router.unlink(path, to: to, as: as, **constraints, &)
    end

    def options(path, to: nil, as: nil, **constraints, &)
      @router.options(path, to: to, as: as, **constraints, &)
    end

    def trace(path, to: nil, as: nil, **constraints, &)
      @router.trace(path, to: to, as: as, **constraints, &)
    end

    def mount(app, at:, **constraints)
      @router.mount(app, at: at, **constraints)
    end

    def redirect(path, to: nil, as: nil, code: DEFAULT_REDIRECT_CODE)
      @router.redirect(path, to: to, as: as, code: code)
    end

    def scope(path, &)
      @router.scope(path, &)
    end

    def root(to: nil, &)
      @router.root(to: to, &)
    end

    def path(...)
      @router.path(...)
    end

    def url(...)
      @router.url(...)
    end

    def call(...)
      @router.call(...)
    end

    DEFAULT_REDIRECT_CODE = 301
  end
end
