# Benchmark ERB vs CGI for escaping HTML

require "bundler/inline"

gemfile do
  gem "benchmark-ips", require: "benchmark/ips"
  gem "erb"
end

HTML = "<foo>&nbsp;</foo>"

Benchmark.ips do |x|
  x.report "CGI.escapeHTML" do
    CGI.escapeHTML(HTML)
  end

  x.report "ERB::Escape.html_escape" do
    ERB::Escape.html_escape(HTML)
  end

  x.compare!
end

__END__

ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [arm64-darwin23]
Warming up --------------------------------------
      CGI.escapeHTML   857.555k i/100ms
ERB::Escape.html_escape
                       856.391k i/100ms
Calculating -------------------------------------
      CGI.escapeHTML      8.548M (± 0.4%) i/s -     42.878M in   5.016329s
ERB::Escape.html_escape
                          8.663M (± 0.6%) i/s -     43.676M in   5.041830s

Comparison:
ERB::Escape.html_escape:  8663040.7 i/s
      CGI.escapeHTML:  8547802.7 i/s - 1.01x  slower
