# Benchmark overhead of creating new Decorator instance for each call vs
# having a static method call.
require "bundler/setup"
require "benchmark/ips"
require "framework"

module X
  def self.blank?(value)
    return true if value.nil?
    return value.strip.empty? if String === value

    false
  end
end

Benchmark.ips do |x|
  x.report "U::StringDecorator.blank?" do
    Framework::U[""].blank?
  end

  x.report "String#strip.empty?" do
    "".strip.empty?
  end

  x.report "X.blank?" do
    X.blank?("")
  end

  x.compare!
end
