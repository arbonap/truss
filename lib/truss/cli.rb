require "byebug"
require_relative "parser"
  class Cli
    extend Parser
    puts Parser.welcome
    puts 'hi!'
    import = Parser.import
  end
