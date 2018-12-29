####
#
# RangeCycle
#
# Factory to make billing period objects
#
####
#
#
module RangeCycle
  # Known Classes that we can create
  #
  SPECIALIZED_CLASSES = {
    'advance' => Advance,
    'arrears' => Arrears,
  }.freeze

  # name:  Advance or Arrears
  # dates: The date boundaries which are converted into RepeatDates
  #        In turn the repeat dates can be used to work out ranges.
  #        (see advance and arrears classes)
  #
  # returns Advance or Arrears initialized with repeat dates covering
  #         the ranges for the cycle.
  #
  # RepeatDate - is day and month pair.
  #
  def self.for(name:, dates:)
    SPECIALIZED_CLASSES[name]
      .new repeat_dates: dates.map { |date| RepeatDate.new date: date }
  end
end
