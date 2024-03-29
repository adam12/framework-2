require "test_init"
require "net/http"

class TestApp < Framework::TestCase
  def test_http_application
    RunningServer.start(__dir__ + "/app/config.ru") do |running_server|
      assert_match "OK", Net::HTTP.get(running_server.uri)
      assert_match "Blog post 4 at http://example.com/posts/4", Net::HTTP.get(running_server.uri + "/posts/4")
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
