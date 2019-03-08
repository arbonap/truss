require 'csv'
require "active_support/all"
require 'active_support/time_with_zone'

module Parser
  class Normalization
    attr_accessor :csv_file

    def initialize(argv)
      @csv_file = argv[0]
    end

    def self.ascii
      # the artii gem creates ascii text
      # this method shells it out
      `artii Truss Parser`
    end

    def self.welcome
      puts 'Hello! Welcome to the Truss Parser that normalizes CSV data.
            A normalized CSV formatted file will be outputted on `stdout`.
            You will also see the normalized output as a CSV in `normalized_data.csv`.
            A warning will be piped to `stderr` if there is any unparseable data,
            and its correspnding row will be dropped from your output.'
    end

    def scrub
      # make sure there is only one argument from STDIN
      validate_args
      # read in CSV with broken unicode from STDIN
      # and scrub the broken bytes
      cleaned_arrays = cleaned_file
      # generate a new CSV without broken unicode
      generate_scrubbed_csv(cleaned_arrays)

      table = CSV.table("scrubbed-sample.csv")

      # drop rows with unparseable DateTimes
      drop_unparseable_time(table)

      output = table.to_a.reject! { |row| row.blank? }
      generate_scrubbed_csv(output)
    end

    def normalize
      CSV.foreach("scrubbed-sample.csv", headers: true, encoding: "utf-8") do |row|
        # convert PST to EST && format timestamps in iso8601
        update_timezone(row, 'Pacific Time (US & Canada)', 'Eastern Time (US & Canada)')

        # any zip codes with less than 5 digits, prepend 0's to them until they are 5 digits long
        validate_zipcode(row['zip'])
         # uppercase all names
         upcase_fullname(row['fullname'])

         # pass address column as is, validate everything is valid unicode
         # else, replace with Unicode Replacement Character
         validate_address(row['address'])

         foo_duration_seconds = calculate_duration(row['fooduration'])
         bar_duration_seconds = calculate_duration(row['barduration'])

        calculate_total_duration(row, foo_duration_seconds, bar_duration_seconds)

        unicode_notes_validation(row['notes'])

        CSV.open('normalized_data.csv', 'a') do |csv|
          csv << row.fields
        end
      end
      File.open('normalized_data.csv').map { |row| puts row }
    end

    def truncate
      File.truncate('normalized_data.csv', 0)
    end

    def generate_scrubbed_csv(arrays)
      CSV.open("scrubbed-sample.csv", "w+") do |csv|
        arrays.map { |ary| csv << ary }
      end
    end

    def validate_args
      if csv_file.split.length != 1
        STDERR.puts "Warning: We need exactly one argument. Please try again with one command-line argument."
        exit
      end
    end

    def cleaned_file
      CSV.parse(File.read("#{csv_file}").scrub)
    end

    def unicode_notes_validation(notes)
      notes = '' if notes.nil?
      notes.encode('UTF-16', :undef => :replace, :invalid => :replace, :replace => '�').encode('UTF-8')
    end

    def upcase_fullname(fullname)
      fullname.upcase!
    end

    def validate_zipcode(zipcode)
      until zipcode.length == 5 do
        zipcode.prepend('0')
      end
    end

    def format_timestamp(timestamp)
      DateTime.strptime(timestamp, '%m/%d/%y %l:%M:%S %p')
    end

    def update_timezone(row, beginning_tz, result_tz)
      Time.zone = beginning_tz
      datetime = format_timestamp(row['timestamp']).in_time_zone(beginning_tz)
      datetime_est = datetime.in_time_zone(result_tz)
      formatted_datetime_est = format_datetime(datetime_est)
      row['timestamp'] = formatted_datetime_est
    end

    def format_datetime(timestamp)
      timestamp.iso8601
    end

    def calculate_total_duration(row, foo_duration_seconds, bar_duration_seconds)
      row['totalduration'] = foo_duration_seconds + bar_duration_seconds
    end

    def calculate_duration(row)
      duration_seconds = Time.strptime(row, '%H:%M:%S.%L').seconds_since_midnight.to_f
      row = duration_seconds
    end

    def drop_unparseable_time(table)
      table.each_with_index do |row, i|
        begin
          calculate_duration(row[:fooduration])
          calculate_duration(row[:barduration])
          format_timestamp(row[:timestamp])
        rescue ArgumentError => e
          STDERR.puts "Warning: Row #{i} will be deleted due to an unparseable Time.
                      The following row of data will be dropped:
                      '#{row}' "
        end
        table.by_row![i].delete_if { |_| e.present? }
      end
    end

    def validate_address(address)
      address = '' if address.nil?
      address.encode('UTF-16', :invalid => :replace, :replace => '�').encode('UTF-8')
    end
  end
end
