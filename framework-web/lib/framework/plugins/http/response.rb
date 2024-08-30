# frozen-string-literal: true

require "rack/response"

module Framework
  module Plugins
    module Http
      # Response instance inside action
      class Response
        def self.new
          rack_response = ::Rack::Response.new
          super(rack_response)
        end

        def initialize(rack_response)
          @rack_response = rack_response
        end

        def write(chunk)
          @rack_response.write(chunk)
        end

        def finish
          @rack_response.finish
        end

        def add_header(key, value)
          @rack_response.add_header(key, value)
        end

        def cache!(duration = 3600, directive: "public")
          @rack_response.cache!(duration, directive: directive)
        end

        def cache_control
          @rack_response.cache_control
        end

        def cache_control=(value)
          @rack_response.cache_control = value
        end

        def content_length
          @rack_response.content_length
        end

        def content_type
          @rack_response.content_type
        end

        def content_type=(value)
          @rack_response.content_type = value
        end

        def delete_cookie(key, value = {})
          @rack_response.delete_cookie(key, value)
        end

        def do_not_cache!
          @rack_response.do_not_cache!
        end

        def etag
          @rack_response.etag
        end

        def etag=(value)
          @rack_response.etag = value
        end

        def headers
          @rack_response.headers
        end

        def header(...)
          @rack_response.header(...)
        end

        def []=(key, value)
          @rack_response[key] = value
        end

        def [](key)
          @rack_response[key]
        end

        def location
          @rack_response.location
        end

        def location=(value)
          @rack_response.location = value
        end

        def media_type
          @rack_response.media_type
        end

        def media_type_params
          @rack_response.media_type_params
        end

        def redirect(target, status = 302)
          @rack_response.redirect(target, status)
        end

        def set_cookie(key, value)
          @rack_response.set_cookie(key, value)
        end

        def status=(code)
          @rack_response.status = code
        end

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
