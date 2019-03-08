require "byebug"
require_relative "parser"
  class Cli
    extend Parser

    puts Parser::Normalization.ascii
    Parser::Normalization.welcome

    @normalization = Parser::Normalization.new(ARGV)
    @normalization.truncate if File.open('normalized_data.csv', "a+").present?
    @normalization.scrub
    @normalization.normalize
  end
