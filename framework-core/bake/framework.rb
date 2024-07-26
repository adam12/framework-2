# Load environment
def environment
  root = Bundler.root
  require File.expand_path("config/environment", root)
end

# Load application
def application
  root = Bundler.root
  require File.expand_path("config/application", root)
end

# Load database
def database
  call("framework:environment")
  require "framework"
  root = Bundler.root
  require File.expand_path("config/database", root)
end

# Run piece of code inside app context
#
# @param input [Any(Input,String)]
def runner(input)
  call("framework:application")

  case input
  in File
    eval(input.read) # standard:disable Security/Eval
  in String
    eval(input) # standard:disable Security/Eval
  end
end

# Boot console
def console
  call("framework:application")
  Framework::Application.subclasses.each { |application| application.start }

  require "irb"

  name = File.basename(Bundler.root)
  variant = Framework::Variant.default
  prompt = "#{name} [#{variant}]"

  IRB.setup(nil)
  IRB.conf[:PROMPT][:FRAMEWORK] = {
    AUTO_INDENT: true,
    PROMPT_I: "#{prompt} > ",
    PROMPT_S: "#{prompt} * ",
    PROMPT_C: "#{prompt} ? ",
    RETURN: "=> %s\n"
  }

  IRB.conf[:PROMPT_MODE] = :FRAMEWORK

  # Values present in ARGV cause IRB to act strangely
  ARGV.clear
  IRB::Irb.new.run
end
