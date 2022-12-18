# frozen-string-literal: true

module Framework
  module Plugins
    module HttpRouter
      class RouteHelpers
        def initialize(router)
          @router = router
        end

        def path(...)
          @router.path(...)
        end

        def url(...)
          @router.url(...)
        end
      end
    end
  end
end
