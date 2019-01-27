require "byebug"
require_relative "parser"
  class Cli
    extend Parser
    puts Parser.welcome
    puts 'hi!'
    Parser.input_csv

  end
