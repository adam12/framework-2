# frozen-string-literal: true

module Framework
  module Plugins
    # CSRF protection for HTTP services.
    #
    # To skip CSRF protection for a specific action, override the `skip_csrf?`
    # method inside the action to return `true`.
    #
    # Invalid tokens raise `Framework::Plugins::HttpCsrf::InvalidToken`.
    #
    # ## Example
    #   class Application < Framework::Application
    #     plugin Framework::Plugins::HttpCsrf
    #   end
    #
    #   # Inside view, render csrf tag
    #   <%= csrf_tag %>
    module HttpCsrf
      # Error raised when token is invalid.
      InvalidToken = Class.new(StandardError)

      # Name of form field used for CSRF token.
      FIELD = "_csrf"

      # Name of session key where CSRF token is stored.
      KEY = "csrf.token"

      # List of HTTP methods where CSRF protection is applied.
      HTTP_METHODS = %w[POST PUT DELETE PATCH]

      def self.before_load(application, **options)
        require "securerandom"
      end

      module ActionMethods
        # Returns HTML element suitable for rendering into form as CSRF tag.
        #
        #   csrf_tag # => "<input type=\"hidden\" name=\"_csrf\" value="...">'
        def csrf_tag
          %(<input type="hidden" name="#{FIELD}" value="#{csrf_token}">)
        end

        # Check if a valid CSRF token is required for this request.
        #
        # This method can be overwritten inside an action to disable CSRF checks
        # for API requests, etc.
        #
        # ## Example
        #   class ApiAction < Application::Action
        #     def call
        #       # Usual action handler
        #     end
        #
        #     def skip_csrf?
        #       true
        #     end
        #   end
        def skip_csrf?
          false
        end

        # Returns the CSRF token for this session.
        #
        #   csrf_token # => "XJ0vTMSjpsgFy1Tqb7x19TgHlhzPp3d_3-tZZT7yHQw"
        def csrf_token
          request.env["rack.session"][KEY] ||= SecureRandom.urlsafe_base64(32)
        end

        # Hook into calling of action to check CSRF if required.
        def before_call
          _check_token unless skip_csrf?
          super
        end

        def _valid_token_found?
          token = csrf_token
          Rack::Utils.secure_compare(request.params[FIELD].to_s, token)
        end

        def _check_token
          return unless HTTP_METHODS.include?(request.request_method)

          _valid_token_found? or raise InvalidToken
        end
      end
    end
  end
end
