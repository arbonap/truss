require 'csv'
require "active_support/all"
require 'active_support/time_with_zone'

module Parser
  def self.welcome
    # the artii gem creates ascii text
    # this method shells it out
    `artii Truss Parser`
  end

  def self.import
    # read in CSV with broken unicode
    # and scrub the broken bytes
    cleaned_arrays = CSV.parse(File.read("sample-with-broken-utf8.csv").scrub)
    # generate a new CSV without broken unicode
    CSV.open("scrubbed-sample.csv", "w+") do |csv|
      cleaned_arrays.map { |ary| csv << ary }
    end

    table = CSV.table("scrubbed-sample.csv")
    table.each_with_index do |row, i|
      begin
        Time.strptime(row[:fooduration], '%H:%M:%S.%L').seconds_since_midnight.to_f
        Time.strptime(row[:barduration], '%H:%M:%S.%L').seconds_since_midnight.to_f
      rescue ArgumentError => e
        STDERR.puts "Warning: #{row} will be deleted due to an unparseable Time"
      end
      table.by_row![i].delete_if { |_| e.present? }
    end

    output = table.to_a.reject! { |row| row.blank? }
    puts "table result: #{table}"
    puts output

    CSV.open("super-scrubbed-sample.csv", "w+") do |csv|
      output.map { |ary| csv << ary }
    end

    csv = CSV.foreach("super-scrubbed-sample.csv", headers: true, encoding: "utf-8") do |row, i|
      # convert PST to EST
      # format timestamps in iso8601
      Time.zone = 'Pacific Time (US & Canada)'
      formatted_datetime = DateTime.strptime(row['timestamp'], '%m/%d/%y %l:%M:%S %p').in_time_zone('Pacific Time (US & Canada)')
      formatted_datetime_est = formatted_datetime.in_time_zone('Eastern Time (US & Canada)').iso8601
      row['timestamp'] = formatted_datetime_est

      # any zip codes with less than 5 digits,
      # prepend 0's to them until they are 5 digits long
       until row['zip'].length == 5 do
         row['zip'].prepend('0')
       end
       # uppercase all names
       row['fullname'].upcase!

       # pass address column as is, validate everything is valid unicode
       # else, replace with Unicode Replacement Character
      #row['Address'].force_encoding('UTF-8').encode('UTF-16', :invalid => :replace, :replace => '�').encode('UTF-8')

       row['address'].encode('UTF-16', :invalid => :replace, :replace => '�').encode('UTF-8')

       foo_duration_seconds = Time.strptime(row['fooduration'], '%H:%M:%S.%L').seconds_since_midnight.to_f
       row['fooduration'] = foo_duration_seconds

       bar_duration_seconds = Time.strptime(row['barduration'], '%H:%M:%S.%L').seconds_since_midnight.to_f
       row['barduration'] = bar_duration_seconds

       row['totalduration'] = foo_duration_seconds + bar_duration_seconds

       row['address'] = '' if row['address'].nil?
       row['notes'] = '' if row['notes'].nil?

       row['notes'].encode('UTF-16', :undef => :replace, :invalid => :replace, :replace => '�').encode('UTF-8')

      puts row.inspect
    end
  end
end
