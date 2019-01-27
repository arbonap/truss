require 'csv'
module Parser
  def self.welcome
    # the artii gem creates ascii text
    # this method shells it out
    `artii Truss Parser`
  end
  def self.input_csv
    output = CSV.foreach("sample.csv")
    byebug
  end
end
