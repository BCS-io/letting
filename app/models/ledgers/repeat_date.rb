####
#
# RepeatDate
#
# Abstraction for repeating dates (day month combinations
# that appear every year).
#
# Wrapping a date up so that it can worry about the end of month and I just add
# and remove days.
#
####
#
class RepeatDate
  include Comparable
  attr_reader :day, :month, :year, :date
  def initialize day:   Time.now.day,
                 month: Time.now.month,
                 year:  Time.now.year,
                 date:  nil
    if date
      @date = date
    else
      @date = Date.new(year, month, day)
    end
  end

  def day
    @date.day
  end

  def month
    @date.month
  end

  def year
    @date.year
  end

  def yesterday
    @date -=  1.day
    self
  end

  def tomorrow
    @date += 1.day
    self
  end

  def last_year
    @date -= 1.year
    self
  end

  def next_year
    @date += 1.year
    self
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [month, day] <=> [other.month, other.day]
  end
end
