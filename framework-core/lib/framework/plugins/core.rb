module Framework
  module Plugins
    module Core
      module RequestMethods
        def params
          env["router.params"]
        end
      end

      module ResponseMethods
      end
    end
  end
end
