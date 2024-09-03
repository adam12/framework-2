require "minitest/autorun"

module Framework
  class TestCase < Minitest::Test
    module Assertions
      # Assert that the expression has changed by a certain value
      #
      # @param expression [String|#call] eval or callable expression which returns an Integer
      # @option diff [Integer] the value to change by
      # @example
      #   assert_difference "User.count" do
      #     User.create(..)
      #   end
      def assert_difference(expression, diff: 1, &block)
        exp =
          if expression.respond_to?(:call)
            expression
          else
            lambda { eval(expression, block.binding) } # rubocop:disable Security/Eval
          end

        before_value = exp.call
        retval = yield

        error = "#{expression} didn't change by #{diff}"
        assert_equal before_value + diff, exp.call, error
        retval
      end
    end

    include Assertions
  end
end
