# encoding: UTF-8
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
    output =
    csv = CSV.foreach("sample.csv", headers: true, :encoding => 'utf-8') do |row|
      Time.zone = 'Pacific Time (US & Canada)'
      formatted_datetime = DateTime.strptime(row[0], '%m/%d/%y %l:%M:%S %p').in_time_zone('Pacific Time (US & Canada)')
      formatted_datetime_est = formatted_datetime.in_time_zone('Eastern Time (US & Canada)').iso8601
      row[0] = formatted_datetime_est
      puts row.inspect
    end
  end
  # options = {col_sep: ";",
  #             row_sep: "\n",
  #             encoding: Encoding::UTF_8
  #            }
  def self.to_csv(fields = column_names, options = {})
    CSV.generate(options) do |csv|
      csv << fields
    end
  end
end
