require "minitest/autorun"

class TestApp < Minitest::Test
  def test_app_boots
    Dir.mktmpdir("app") do |dir|
      File.write(File.join(dir, "config.ru"), <<~'RUBY')
        require "framework"

        module Blog
          module Controllers
            module Posts
              class Show
                include Framework::Action

                def call
                  response.write "Blog post #{request.params[:id]}"
                  response.finish
                end
              end
            end
          end
        end

        class Baz
          module Controllers
            module Foobars
              class FoobarBaz
                include Framework::Action

                def call
                  response.write "OK"
                  response.finish
                end
              end
            end
          end

          class Application < Framework::Application
          end

          class Routes < Framework::Routes
            define do
              get "/", to: Baz::Controllers::Foobars::FoobarBaz
              get "/posts/:id", to: Blog::Controllers::Posts::Show
            end
          end
        end

        run Baz::Application.start
      RUBY

      child = spawn("rackup -q -p 61333 -I#{Dir.pwd}/lib config.ru", chdir: dir)
       # Wait for process to boot
      sleep 1

      assert_match "OK", `curl --silent -q localhost:61333`
      assert_match "Blog post 4", `curl --silent -q localhost:61333/posts/4`
    ensure
      Process.kill("INT", child) if child
      # Wait for child to exit successfully
      Process.waitall
    end
  end
end
