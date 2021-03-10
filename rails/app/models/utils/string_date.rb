####
#
# StringDate
#
# Safe Parsing of a string into a date.
#
####
#
class StringDate
  attr_reader :datestring

  def initialize datestring
    @datestring = datestring
  end

  def to_date
    Date.parse datestring
  rescue StandardError
    nil
  end
end
