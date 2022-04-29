# frozen-string-literal: true

require "hanami/router"
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
      begin
        route_class = Kernel.const_get(application.namespace)::Routes
      rescue NameError
        # Define empty routes class if none has been defined
        Kernel.const_get(application.namespace).const_define(:Routes, Class.new(Framework::Routes))
      end

      router = Hanami::Router.new(base_url: application.config.http_router.base_url, resolver: resolver)

      new(router, &route_class.routes)
    end

    def get(path, to: nil, as: nil, **constraints, &blk)
      @router.get(path, to: to, as: as, **constraints, &blk)
    end

    def post(path, to: nil, as: nil, **constraints, &blk)
      @router.post(path, to: to, as: as, **constraints, &blk)
    end

    def patch(path, to: nil, as: nil, **constraints, &blk)
      @router.patch(path, to: to, as: as, **constraints, &blk)
    end

    def put(path, to: nil, as: nil, **constraints, &blk)
      @router.put(path, to: to, as: as, **constraints, &blk)
    end

    def delete(path, to: nil, as: nil, **constraints, &blk)
      @router.delete(path, to: to, as: as, **constraints, &blk)
    end

    def link(path, to: nil, as: nil, **constraints, &blk)
      @router.link(path, to: to, as: as, **constraints, &blk)
    end

    def unlink(path, to: nil, as: nil, **constraints, &blk)
      @router.unlink(path, to: to, as: as, **constraints, &blk)
    end

    def options(path, to: nil, as: nil, **constraints, &blk)
      @router.options(path, to: to, as: as, **constraints, &blk)
    end

    def trace(path, to: nil, as: nil, **constraints, &blk)
      @router.trace(path, to: to, as: as, **constraints, &blk)
    end

    def mount(app, at:, **constraints)
      @router.mount(app, at: at, **constraints)
    end

    def redirect(path, to: nil, as: nil, code: DEFAULT_REDIRECT_CODE)
      @router.redirect(path, to: to, as: as, code: code)
    end

    def scope(path, &blk)
      @router.scope(path, &blk)
    end

    def root(to: nil, &blk)
      @router.root(to: to, &blk)
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
