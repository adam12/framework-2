# frozen-string-literal: true

module Framework
  module Plugins
    # Render a String response after an Action has been called
    module RenderResponse
      module ActionMethods
        def after_call(res)
          case res
          in [Integer, Hash, Array]
            res
          in String
            _response.write(res)
            _response.finish
          in NilClass
            _response.finish
          end
        end
      end
    end
  end
end
