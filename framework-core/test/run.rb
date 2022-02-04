require "minitest/autorun"

Dir.glob("test/**/test_*.rb").each { |f| require "./#{f}" }
