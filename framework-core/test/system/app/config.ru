require "framework"
require "framework-web"

module Blog
  class Application < Framework::Application
    plugin Framework::Plugins::Http
    plugin Framework::Plugins::HttpRouter

    config.http_router.base_url = "http://example.com"

    require "rack/runtime"
    config.http_router.middleware.use Rack::Runtime

    require "framework/plugins/h"
    plugin Framework::Plugins::H
  end

  class Routes < Framework::Routes
    define do
      get "/", to: Blog::Controllers::Posts::Index
      get "/posts/:id", to: Blog::Controllers::Posts::Show, as: :show
    end
  end

  module Controllers
    module Posts
      class Index < Application::Action
        def call
          response.write "OK"
          response.finish
        end
      end

      class Show < Application::Action
        def call
          id = request.params[:id]
          response.write "Blog post #{h id} at #{h routes.url(:show, id: id).to_s}"
          response.finish
        end
      end
    end
  end
end

run Blog::Application.start
