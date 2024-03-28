module Framework
  module Validation
    class Errors < Hash
      def add(key, message)
        self[key] ||= []
        self[key] << message
      end
    end

    class Result
      attr_accessor :success
      attr_accessor :failure

      def initialize
        @success = default_success
        @failure = default_failure
      end

      private

      def default_success
        proc { raise "Success handler wasn't overridden" }
      end

      def default_failure
        proc { raise "Failure handler wasn't overridden" }
      end
    end

    module ClassMethods
      def call(...)
        new.call(...)
      end
    end

    module InstanceMethods
      def errors
        @errors ||= Validation::Errors.new
      end

      def validate
      end

      def call(...)
        errors.clear
        validate(...)
        result = Result.new
        yield result

        if errors.none?
          result.success.call
        elsif result.failure.arity == 1
          result.failure.call(errors)
        else
          result.failure.call
        end
      end

      def valid?(...)
        errors.clear
        validate(...)
        errors.any?
      end
    end

    def self.included(base)
      super

      base.class_eval do
        include InstanceMethods
        extend ClassMethods
      end
    end
  end
end
