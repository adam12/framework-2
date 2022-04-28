require "minitest/autorun"
require "net/http"

class TestApp < Minitest::Test
  def test_app_boots
    Dir.mktmpdir("app") do |dir|
      File.write(File.join(dir, "config.ru"), <<~'RUBY')
        require "framework"

        module Blog
          class Application < Framework::Application
            config.http_router.base_url = "foo"

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
              class Index < Application::FrameworkAction
                def call
                  response.write "OK"
                  response.finish
                end
              end

              class Show < Application::FrameworkAction
                def call
                  id = request.params[:id]
                  response.write "Blog post #{h id} at #{h routes.url(:show, id: id)}"
                  response.finish
                end
              end
            end
          end
        end

        run Blog::Application.start(base_url: "http://example.com")
      RUBY

      RunningServer.start(dir + "/config.ru") do |running_server|
        assert_match "OK", Net::HTTP.get(running_server.uri)
        assert_match "Blog post 4 at http://example.com/posts/4", Net::HTTP.get(running_server.uri + "/posts/4")
      end
    end
  end

  RunningServer = Struct.new(:hostname, :port) do
    def uri
      URI("http://#{hostname}:#{port}")
    end

    def self.start(rackup_file)
      require "rack"
      app, _options = Rack::Builder.load_file(rackup_file)
      server = Rack::Server.new(app: app, Port: 61333, AccessLog: [])
      Thread.new do
        server.start
      end

      loop do
        TCPSocket.new("localhost", 61333)
        break
      rescue
        sleep 0.1
        retry
      end

      yield new("localhost", 61333)
    ensure
      server&.server&.shutdown
    end
  end
end
