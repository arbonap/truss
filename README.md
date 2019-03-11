# Truss 🚀

Welcome to TrussParser! This is a gem that parses and normalizes CSV data according to the specs in `challenge.md`


## Installation

Assuming you have an environment set up for the Ruby ecosystem:

    $ gem install truss

## Usage

- After `gem install`ing the `truss` gem:
  - Run `truss sample.csv` to parse and normalize the `sample.csv` that is shipped along in this gem. Alternatively, you can also run `truss sample-with-broken-utf8.csv` as well. The Truss takes in a CSV file as an argument, and outputs normalized CSV data in `normalized_data.csv`.

## Testing

- Run `rake spec` to run the RSpec tests.
- You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Truss project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/truss/blob/master/CODE_OF_CONDUCT.md).
