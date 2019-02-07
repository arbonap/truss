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
    cleaned_arrays = CSV.parse(File.read("sample-with-broken-utf8.csv").scrub)

    CSV.open("scrubbed-sample.csv", "a+") do |csv|
      cleaned_arrays.map { |ary| csv << ary }
    end

    csv = CSV.foreach("scrubbed-sample.csv", headers: true, encoding: "utf-8") do |row|
      Time.zone = 'Pacific Time (US & Canada)'
      formatted_datetime = DateTime.strptime(row['Timestamp'], '%m/%d/%y %l:%M:%S %p').in_time_zone('Pacific Time (US & Canada)')
      formatted_datetime_est = formatted_datetime.in_time_zone('Eastern Time (US & Canada)').iso8601
      row['Timestamp'] = formatted_datetime_est
      puts row.inspect
    end
  end
end
