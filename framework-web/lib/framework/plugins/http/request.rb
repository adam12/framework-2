# frozen-string-literal: true

require "rack/request"

module Framework
  module Plugins
    module Http
      class Request
        def self.new(env)
          rack_request = ::Rack::Request.new(env)
          super(rack_request)
        end

        def initialize(rack_request)
          @rack_request = rack_request
        end

        def params
          @rack_request.params
        end

        def accept_encoding
          @rack_request.accept_encoding
        end

        def accept_language
          @rack_request.accept_language
        end

        def authority
          @rack_request.authority
        end

        def base_url
          @rack_request.base_url
        end

        def body
          @rack_request.body
        end

        def content_charset
          @rack_request.content_charset
        end

        def content_length
          @rack_request.content_length
        end

        def content_type
          @rack_request.content_type
        end

        def cookies
          @rack_request.cookies
        end

        def delete?
          @rack_request.delete?
        end

        def form_data?
          @rack_request.form_data?
        end

        def forwarded_authority
          @rack_request.forwarded_authority
        end

        def forwarded_for
          @rack_request.forwarded_for
        end

        def forwarded_port
          @rack_request.forwarded_port
        end

        def fullpath
          @rack_request.fullpath
        end

        def get?
          @rack_request.get?
        end

        def head?
          @rack_request.head?
        end

        def host
          @rack_request.host
        end

        def host_authority
          @rack_request.host_authority
        end

        def host_with_port
          @rack_request.host_with_port
        end

        def hostname
          @rack_request.hostname
        end

        def ip
          @rack_request.ip
        end

        def link?
          @rack_request.link?
        end

        def logger
          @rack_request.logger
        end

        def media_type
          @rack_request.media_type
        end

        def media_type_params
          @rack_request.media_type_params
        end

        def options?
          @rack_request.options?
        end

        def parseable_data?
          @rack_request.parseable_data?
        end

        def patch?
          @rack_request.patch?
        end

        def path
          @rack_request.path
        end

        def path_info
          @rack_request.path_info
        end

        def path_info=(value)
          @rack_request.path_info = value
        end

        def port
          @rack_request.port
        end

        def post?
          @rack_request.post?
        end

        def put?
          @rack_request.put?
        end

        def query_string
          @rack_request.query_string
        end

        def referer
          @rack_request.referer
        end

        def request_method
          @rack_request.request_method
        end

        def scheme
          @rack_request.scheme
        end

        def script_name
          @rack_request.script_name
        end

        def script_name=(value)
          @rack_request.script_name = value
        end

        def server_authority
          @rack_request.server_authority
        end

        def server_name
          @rack_request.server_name
        end

        def server_port
          @rack_request.server_port
        end

        def session
          @rack_request.session
        end

        def session_options
          @rack_request.session_options
        end

        def ssl?
          @rack_request.ssl?
        end

        def trace?
          @rack_request.trace?
        end

        def trusted_proxy?
          @rack_request.trusted_proxy?
        end

        def unlink?
          @rack_request.unlink?
        end

        def url
          @rack_request.url
        end

        def user_agent
          @rack_request.user_agent
        end

        def values_at
          @rack_request.values_at
        end

        def xhr?
          @rack_request.xhr?
        end

        def env
          @rack_request.env
        end

        def get_header(name)
          @rack_request.get_header(name)
        end

        def has_header?(name)
          @rack_request.has_header?(name)
        end

        def delete_header(name)
          @rack_request.delete_header(name)
        end

        def each_header(&)
          @rack_request.each_header(&)
        end

        def fetch_header(name, &)
          @rack_request.fetch_header(name, &)
        end
      end
    end
  end
end
