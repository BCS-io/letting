####
#
# DueOn
#
# The day and month during the year to charge a property.
#
# Charges will become due every year on the described date. By holding a
# day and month a charge is due we can handle recurring charges.
#
# The code is part of the charge system in the accounts.
#
# day - day which the charge becomes due
# month - month which the charge becomes due
# year - nil on recurring due_ons
#        set to year for one off charges.
#
# More information: due_ons.rb
#
####
#
class DueOn < ActiveRecord::Base
  include Comparable
  belongs_to :cycle, counter_cache: true, inverse_of: :due_ons
  validates :month, numericality: { only_integer: true,
                                    greater_than: -2,
                                    less_than: 13 }
  validates :day,   numericality: { only_integer: true,
                                    greater_than: 0,
                                    less_than: 32 }

  validates :year, numericality: { only_integer: true,
                                   greater_than: 1990,
                                   less_than: 2030 },
                   allow_nil: true

  validates :show_month, numericality: { only_integer: true,
                                         greater_than: -2,
                                         less_than: 13 },
                         allow_nil: true
  validates :show_day,   numericality: { only_integer: true,
                                         greater_than: 0,
                                         less_than: 32 },
                         allow_nil: true
  validates :show_month, :show_day, presence: true, if: :show?

  # between range - MatchedDueOn's for the given date range
  # range - date range (but converts datetime to date range)
  # Multi-year ranges produced multiple MatchedDueOn's
  #
  def between range
    date_range = to_date_range range
    matched = date_range.to_a
                        .map(&:year)
                        .uniq.map { |year| Date.new(year, month, day) }
                        .sort & date_range.to_a
    matched.map { |date| MatchedDueOn.new date, show_date(year: date.year) }
  end

  # show_date(year:)
  # year - year which the date will be given
  #
  def show_date(year:)
    if show_month.nil? && show_day.nil?
      Date.new year, month, day
    else
      Date.new year, show_month, show_day
    end
  end

  def show?
    !(show_month.nil? && show_day.nil?)
  end

  def clear_up_form
    mark_for_destruction if empty?
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  # Convention is == is Matching on values rather than object structure
  # <=> is called in the implementation of ==
  #
  def <=> other
    return nil unless other.is_a?(self.class)
    [month, day, show_month] <=>
      [other.month, other.day, other.show_month]
  end

  def to_s
    if year
      "[#{Date.new(year, month, day).strftime('%Y %b %e')}"\
        "#{' MFD' if marked_for_destruction?}]"
    else
      "[#{Date.new(2002, month, day).strftime('%b %e')}"\
        "#{' MFD' if marked_for_destruction?}]"
    end
  end

  private

  def to_date_range datetime_range
    (datetime_range.first.to_date..datetime_range.last.to_date)
  end

  def ignored_attrs
    %w[id cycle_id created_at updated_at]
  end
end
