# frozen-string-literal: true

require "rack"

module Framework
  module Plugins
    module Http
      class Request < ::Rack::Request
      end
    end
  end
end
