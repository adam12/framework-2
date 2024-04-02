# Benchmark overhead of creating new Decorator instance for each call vs
# having a static method call.

require "bundler/inline"
require "delegate"

gemfile do
  gem "benchmark-ips", require: "benchmark/ips"
end

module U
  class StringDecorator < DelegateClass(String)
    def blank?
      strip.empty?
    end
  end

  def self.[](value)
    StringDecorator.new(value)
  end
end

module X
  def self.blank?(value)
    return true if value.nil?
    return value.strip.empty? if String === value

    false
  end
end

module Y
  def blank?
    return true if NilClass === self
    return strip.empty? if ::String === self

    false
  end
end

Benchmark.ips do |x|
  x.report "U::StringDecorator.blank?" do
    U[""].blank?
  end

  x.report "String#strip.empty?" do
    "".strip.empty?
  end

  x.report "X.blank?" do
    X.blank?("")
  end

  x.report "extend Y" do
    "".extend(Y).blank?
  end

  x.compare!
end

__END__

ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [arm64-darwin23]
Warming up --------------------------------------
U::StringDecorator.blank?
                       305.967k i/100ms
 String#strip.empty?     1.323M i/100ms
            X.blank?   935.977k i/100ms
            extend Y   110.681k i/100ms
Calculating -------------------------------------
U::StringDecorator.blank?
                          3.073M (± 0.2%) i/s -     15.604M in   5.077958s
 String#strip.empty?     13.036M (± 5.8%) i/s -     66.134M in   5.098702s
            X.blank?      9.116M (± 2.0%) i/s -     45.863M in   5.033354s
            extend Y      1.094M (± 3.0%) i/s -      5.534M in   5.062360s

Comparison:
 String#strip.empty?: 13035665.7 i/s
            X.blank?:  9115501.8 i/s - 1.43x  slower
U::StringDecorator.blank?:  3072969.7 i/s - 4.24x  slower
            extend Y:  1094192.4 i/s - 11.91x  slower
