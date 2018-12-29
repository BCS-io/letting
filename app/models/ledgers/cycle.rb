####
# Cycle
#
# Represents the repeated dates a charge becomes due in the year
#
# Charges have one of a few number of patterns of repeated due_dates.
# A cycle has a name identifier and a number of the repeated dates.
# A charge belongs to a Cycle and a Cycle has many charges.
#
# Cycle has many due_ons (the dates when a charge happens, becomes due)
#
####
#
class Cycle < ActiveRecord::Base
  include Comparable
  enum charged_in: %i[arrears advance]
  has_many :charges, inverse_of: :cycle

  validates :name, :order, :due_ons, presence: true
  validates :cycle_type, inclusion: { in: %w[term monthly] }
  validates :charged_in, inclusion: { in: charged_ins.keys }
  include DueOns
  accepts_nested_attributes_for :due_ons, allow_destroy: true
  before_validation :clear_up_form

  delegate :clear_up_form, to: :due_ons

  def monthly?
    cycle_type == 'monthly'
  end

  def prepare
    due_ons.prepare type: cycle_type
  end

  # between billing_period
  # billing_period - range of dates covering the time we wish to charge for
  # returns: MatchedCycle - matched due_date and billing_period date range
  #          parings
  #
  def between billing_period
    due_ons.between(billing_period).map do |match|
      MatchedCycle.new(match.spot, bill_period(billed_on: match.show))
    end
  end

  # required to be public for importing accounts information
  # billed_on: date within the billing period
  #            anchored by the billed_on's year.
  #
  # returns:   range covering the billing period
  #
  def bill_period(billed_on:)
    RangeCycle.for(name: charged_in, dates: show_dates(year: billed_on.year))
              .duration within: billed_on
  end

  def <=> other
    return nil unless other.is_a?(self.class)

    [charged_in, due_ons.sort] <=> [other.charged_in, other.due_ons.sort]
  end

  scope :by_order, -> { order(order: :asc) }

  def to_s
    "cycle: #{name}, type: #{cycle_type}, charged_in: #{charged_in}, " +
      due_ons.to_s
  end

  private

  def show_dates(year:)
    due_ons.map { |due_on| due_on.show_date year: year }
  end
end
