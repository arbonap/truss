require "byebug"
require_relative "parser"
  class Cli
    extend Parser
    puts Parser.welcome
    puts 'hi!'
    Parser.truncate if File.open('normalized_data.csv', "a+").present?
    Parser.import
  end
