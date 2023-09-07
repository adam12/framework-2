# Load IRB repl with framework loaded
def console
  require "framework"
  require "irb"
  ARGV.clear
  IRB.start
end
