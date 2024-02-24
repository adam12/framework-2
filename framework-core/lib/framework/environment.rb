require "dotenv"
require "framework/variant"

module Framework
  module Environment
    def self.load
      dotenv_files = [
        ".env.#{Framework::Variant.default}",
        ".env"
      ]

      Dotenv.load(*dotenv_files)
    end
  end
end
