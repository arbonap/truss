# encoding: UTF-8
require 'csv'
module Parser
  def self.welcome
    # the artii gem creates ascii text
    # this method shells it out
    `artii Truss Parser`
  end
  def self.import
    csv = CSV.foreach("sample.csv", headers: true, :encoding => 'utf-8') do |row|
      # formatted_datetime = DateTime.parse(row[0]).iso8601
      # row[0] = formatted_datetime
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
