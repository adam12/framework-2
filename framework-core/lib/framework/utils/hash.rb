module Framework
  module Utils
    module Hash
      ##
      # Deep symbolize all keys of the Hash.
      def self.deep_symbolize_keys(hash)
        hash.each_with_object({}) { |(key, value), result|
          new_key =
            case key
            when ::String
              key.to_sym
            else
              key
            end

          new_value =
            case value
            when ::Hash then deep_symbolize_keys(value)
            else value
            end

          result[new_key] = new_value
        }
      end
    end
  end
end
