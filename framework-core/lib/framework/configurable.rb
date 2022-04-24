# frozen-string-literal: true

require "dry-configurable"

module Framework
  module Configurable
    def self.extended(base)
      base.extend Dry::Configurable
    end
  end
end
