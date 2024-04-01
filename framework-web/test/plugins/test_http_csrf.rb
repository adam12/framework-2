require "test_init"
require "framework"
require "framework-web"

class Framework::Plugins::TestHttpCsrf < Framework::TestCase
  def test_csrf_tag
    application = Class.new(Framework::Application) do
      plugin Framework::Plugins::Http
      plugin Framework::Plugins::HttpRouter
      plugin Framework::Plugins::HttpSession, secret: "SECRET"
      plugin Framework::Plugins::HttpCsrf
    end

    action = Class.new(application::Action) do
      def call
        response.write csrf_tag
        response.finish
      end
    end

    routes = Class.new(Framework::Routes) do
      define do
        get "/", to: action
      end
    end

    application.namespace.const_set(:Routes, routes)

    env = Rack::MockRequest.env_for("/")
    _, _, body = application.build.to_app.call(env)

    assert body.first.match?(/<input type="hidden" name="_csrf" value=".*?">/)
  end

  def test_valid_csrf_token
    application = Class.new(Framework::Application) do
      plugin Framework::Plugins::Http
      plugin Framework::Plugins::HttpRouter
      plugin Framework::Plugins::HttpSession, secret: "SECRET"
      plugin Framework::Plugins::HttpCsrf
    end

    action = Class.new(application::Action) do
      def call
        response.write(csrf_token)
        response.finish
      end
    end

    routes = Class.new(Framework::Routes) do
      define do
        get "/", to: action
        post "/", to: action
      end
    end

    application.namespace.const_set(:Routes, routes)

    env = Rack::MockRequest.env_for("/", method: "GET")
    _, _, body = application.build.to_app.call(env)
    rack_session = env["rack.session"]
    token = body[0]

    env = Rack::MockRequest.env_for("/", method: "POST", params: {"_csrf" => token})
    env["rack.session"] = rack_session

    status, _, _body = application.build.to_app.call(env)

    assert status == 200
  end

  def test_invalid_csrf_token
    application = Class.new(Framework::Application) do
      plugin Framework::Plugins::Http
      plugin Framework::Plugins::HttpRouter
      plugin Framework::Plugins::HttpSession, secret: "SECRET"
      plugin Framework::Plugins::HttpCsrf
    end

    action = Class.new(application::Action) do
      def call
        response.write "OK"
        response.finish
      end
    end

    routes = Class.new(Framework::Routes) do
      define do
        post "/", to: action
      end
    end

    application.namespace.const_set(:Routes, routes)

    env = Rack::MockRequest.env_for("/", method: "POST")
    assert_raises(Framework::Plugins::HttpCsrf::InvalidToken) do
      application.build.to_app.call(env)
    end
  end

  def test_skip_csrf
    application = Class.new(Framework::Application) do
      plugin Framework::Plugins::Http
      plugin Framework::Plugins::HttpRouter
      plugin Framework::Plugins::HttpSession, secret: "SECRET"
      plugin Framework::Plugins::HttpCsrf
    end

    action = Class.new(application::Action) do
      def call
        response.write "OK"
        response.finish
      end

      def skip_csrf?
        true
      end
    end

    routes = Class.new(Framework::Routes) do
      define do
        post "/", to: action
      end
    end

    application.namespace.const_set(:Routes, routes)
    env = Rack::MockRequest.env_for("/", method: "POST")

    # Nothing raised
    assert application.build.to_app.call(env)
  end
end
