####
#
# Debit
#
# Why does this class exist?
#
# It represents an item of debit held under a property's account.
#
# How does it fit in to the larger system?
#
# Properties have charges which become due. The act of become due is to
# generate debits for a charge on a particular date - it then sits against
# the property's account. Credits made by tenants offset these debits.
#
# When a charge is being generated the generation system checks against when
# the debit became due to see if the property has already been charged against
# for this time period.
#
# Debits increase an accounts balance +.
#
####
#
class Debit < ActiveRecord::Base
  include Comparable
  belongs_to :account, inverse_of: :debits
  has_many :credits, through: :settlements
  has_many :settlements, dependent: :destroy
  belongs_to :charge, inverse_of: :debits
  belongs_to :snapshot, inverse_of: :debits

  def period
    (period_first..period_last)
  end

  def period=(bill_range)
    self.period_first = bill_range.first
    self.period_last  = bill_range.last
  end

  validates :charge, :on_date, presence: true
  validates :amount, price_bound: true
  before_save :reconcile

  delegate :automatic_payment?, to: :charge
  delegate :charge_type, to: :charge

  # Amount left to pay off on the debit.
  def outstanding
    amount - settled
  end

  # If the debit has been settled or not.
  def paid?
    amount.round(2) == settled.round(2)
  end

  def <=> other
    return nil unless other.is_a?(self.class)
    [charge_id, on_date, amount] <=>
      [other.charge_id, other.on_date, other.amount]
  end

  # has a debit with charge and date exist?
  def like? other
    charge_id == other.charge_id && on_date == other.on_date
  end

  def to_debitable
    {
      charge_type: charge_type,
      automatic_payment: automatic_payment?,
      date_due: on_date,
      period: period,
      amount: amount,
    }
  end

  scope :total, -> { sum(:amount)  }
  scope :until, -> (until_time) { where('? >= on_date', until_time) }

  # charge_id - the charge's being queried for unpaid debits.
  # returns unpaid debits for the charge_id
  #
  def self.available charge_id
    where(charge_id: charge_id).order(:on_date).reject(&:paid?)
  end

  # Calculation of the outstanding debt on a charge
  #
  def self.debt_on_charge charge_id
    available(charge_id).to_a.sum(&:outstanding)
  end

  def to_s
    "id: #{id || 'nil'}, " \
    "charge_id: #{charge_id || 'nil'}, " \
    "on_date: #{on_date.to_date}+t, " \
    "period: #{period}, " \
    "outstanding: #{outstanding}, " \
    "amount: #{amount}, " +
      charge_to_s
  end

  private

  def settled
    settlements.pluck(:amount).inject(0, :+)
  end

  # Called on save to see if a debit can be matched to a credit
  #
  def reconcile
    Settlement.resolve(outstanding,
                       Credit.available(charge_id)) do |offset, pay|
      settlements.build(credit: offset, amount: pay)
    end
  end

  def charge_to_s
    if charge
      "charge_type: #{charge_type || 'nil' } " \
      "auto: #{automatic_payment? || 'nil' } "
    else
      'charge: nil'
    end
  end
end
