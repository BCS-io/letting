####
#
# Advance
#
# Returns a period given a date within
#
# RangeCycle is the factory for billing range objects such as Advance and
# arrears.
#
# Initialize takes the repeated dates and calculates the period ranges from
# this - example 25th Mar and 30th Sep would result in two periods.
# 1) 25th Mar - 29th Sep
# 2) 30th Sep - 24th Mar of next year.
#
# As it stands: Ranges match on the date the bill becomes due. With advance
# this means the start, or first, date of a range - it then builds up the
# range and returns this to the caller.
#
# A useless assignment which increases human reader's comprehension.
#
####
#
class Advance
  attr_reader :periods

  def initialize(repeat_dates:)
    self.periods = repeat_dates unless repeat_dates.empty?
  end

  # duration - returns the period covered by the within date.
  # within:  - the date we want to know the period for
  #
  def duration(within:)
    found_period = periods.find do |period|
      (period.first..period.last).cover? RepeatDate.new(date: within)
    end
    return :missing_due_on unless found_period
    found_period.first.date..found_period.last.date
  end

  # makes period's boundary date-pairs
  # repeat_dates - the start date of the period
  #
  def periods=(repeat_dates)
    period_starts = repeat_dates
    @periods = period_starts.zip(period_ends(repeat_dates))
  end

  private

  # Creating the end pairs for advance date ranges.
  # @repeat_dates: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  F -1D   G -1D   H -1D   E -1D +1Y
  def period_ends repeat_dates
    ends = Marshal.load(Marshal.dump(repeat_dates)).rotate(1).map(&:yesterday)
    ends[-1] = ends[-1].next_year
    ends
  end
end
