module Framework
  module Utils
    module Blank
      def self.blank?(value)
        return true if value.nil?
        return value.strip.empty? if ::String === value

        false
      end

      def self.present?(value)
        !blank?(value)
      end
    end
  end
end
