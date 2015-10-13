####
#
# Arrears
#
# Returns a period given a date within
#
# See Advance for more information.
#
# A useless assignment which increases human reader's comprehension.
#
####
#
class Arrears
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
  # repeat_dates - the end date of the period
  #
  def periods=(repeat_dates)
    period_ends = repeat_dates
    @periods = period_starts(repeat_dates).zip period_ends
  end

  private

  # Creating the start pairs for arrears date periods.
  # @repeat_dates: [E, F, G, H]
  #
  # Begin With:  E       F       G       H
  # End   With:  H +1D   E +1D   F +1D   G +1D -1Y
  def period_starts repeat_dates
    starts = Marshal.load(Marshal.dump(repeat_dates)).rotate(-1).map(&:tomorrow)
    starts[0] = starts[0].last_year
    starts
  end
end
