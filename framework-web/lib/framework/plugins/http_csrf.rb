module Framework
  module Plugins
    module HttpCsrf
      InvalidToken = Class.new(StandardError)

      FIELD = "_csrf"
      KEY = "csrf.token"
      HTTP_METHODS = %w[POST PUT DELETE PATCH]

      def self.before_load(application, **options)
        require "securerandom"
      end

      module ActionMethods
        def csrf_tag
          %(<input type="hidden" name="#{FIELD}" value="#{csrf_token}">)
        end

        # Should CSRF be checked for this request.
        #
        # Overwrite in Action to skip CSRF checks
        def skip_csrf?
          false
        end

        # CSRF token for this request.
        def csrf_token
          request.env["rack.session"][KEY] ||= SecureRandom.urlsafe_base64(32)
        end

        # Hook into calling of action to check CSRF if required.
        def around_call
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
