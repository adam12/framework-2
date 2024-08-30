# frozen-string-literal: true

require "rack"

module Framework
  module Plugins
    module Http
      # Response instance inside action
      class Response < ::Rack::Response
        # Immediately halt request with provided response
        #
        #   response.halt(200)
        #   response.halt("This is the body")
        #   response.halt(200, "This is the body")
        def halt(*res)
          case res
          in [Integer => status]
            self.status = status
          in [String => body]
            write(body)
          in [Integer => status, String => body]
            self.status = status
            write(body)
          end

          throw :halt, finish
        end
      end
    end
  end
end
