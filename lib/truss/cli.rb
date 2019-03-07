require "byebug"
require_relative "parser"
  class Cli
    extend Parser
    puts Parser.welcome
    puts 'Hello! Welcome to the Truss Parser that normalizes CSV data.
          A normalized CSV formatted file will be outputted on `stdout`.
          You will also see the normalized output as a CSV in `normalized_data.csv`.
          A warning will be piped to `stderr` if there is any unparseable data,
          and its correspnding row will be dropped from your output.'
    Parser.truncate if File.open('normalized_data.csv', "a+").present?
    Parser.import
  end
