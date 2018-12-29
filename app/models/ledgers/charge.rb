####
#
# A charge that is applied to a property's account.
#
# A charge represents the type, amount and, through due_ons, the date that
# a property should become due a charge.
#
# The code is part of the charge system in the accounts. Charges are
# associated with a property's account. When an operator decides they want to
# bill a group of properties. Charges are generated according to this
# information using the invoicing system. The information is passed, as a
# chargeable, to becomes a debit in the property's account.debits
#
####
#
class Charge < ActiveRecord::Base
  enum payment_type: %i[manual automatic]
  enum activity: %i[dormant active]
  belongs_to :account
  has_many :credits, dependent: :destroy, inverse_of: :charge
  has_many :debits, dependent: :destroy, inverse_of: :charge
  belongs_to :cycle, inverse_of: :charges

  validates :charge_type, :cycle, presence: true
  validates :payment_type, inclusion: { in: payment_types.keys }
  validates :activity, inclusion: { in: activities.keys }
  validates :amount, price_bound: true, if: :active?

  delegate :monthly?, to: :cycle
  delegate :charged_in, to: :cycle

  # billing_period - the date range that we generate charges for.
  # returns        - chargable_info array with data required to bill the
  #                  associated account. Empty array if nothing billed.
  def coming billing_period
    return [] if dormant?
    cycle.between(billing_period).map do |matched_cycle|
      make_chargeable(matched_cycle)
    end.compact
  end

  def prepare
    # maybe should be calling prepare on charge structure
  end

  def clear_up_form
    mark_for_destruction if empty?
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  def to_s
    "charge: #{charge_type}, #{cycle}"
  end

  private

  # Converts a Charge object into a Chargeable object.
  # matched_cycle - struct of date the charge becomes due, spot, and
  #                 the period it is billed for, period.
  # returns   - The information to bill, debit, the associated account.
  #
  def make_chargeable matched_cycle
    Chargeable.from_charge charge_id:  id,
                           at_time:    matched_cycle.spot,
                           amount:     amount,
                           account_id: account_id,
                           period:     matched_cycle.period
  end

  def ignored_attrs
    %w(id account_id activity created_at updated_at)
  end
end
