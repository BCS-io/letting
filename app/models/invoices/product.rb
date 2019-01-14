####
#
# Product
#
# Product is a line item on the invoice.
#
# Invoices are created of property related information and the billed charges
# for a period. The product are these billed charges plus any arrears.
#
####
#
class Product < ApplicationRecord
  include Comparable
  enum payment_type: %i[manual automatic]
  belongs_to :invoice, inverse_of: :products, optional: true

  validates :amount, :charge_type, :date_due, presence: true
  validates :payment_type, inclusion: { in: payment_types.keys }

  def period
    (period_first..period_last)
  end

  def period=(bill_range)
    self.period_first = bill_range.first
    self.period_last  = bill_range.last
  end

  def arrears?
    charge_type == ChargeTypes::ARREARS
  end

  # Wrapper for the arguments required for an Arrears product item.
  # All the other product items are taken from the debit.
  #
  def self.arrears(account:, date_due:)
    Product.new charge_type: ChargeTypes::ARREARS,
                date_due: date_due,
                payment_type: 'automatic',
                amount: account.balance_all_credits(to_time: date_due),
                balance: account.balance_all_credits(to_time: date_due)
  end

  # Scope to return products that trigger the back page of the invoice
  # These are displayed on the backpage.
  #
  def self.page2
    where(charge_type: [ChargeTypes::GROUND_RENT,
                        ChargeTypes::GARAGE_GROUND_RENT])
      .order(charge_type: :desc).first
  end

  # ordering line item charges on the first page of the invoice.
  #
  def self.order_by_date_then_charge
    order(date_due: :asc, charge_type: :asc)
  end

  # Does the product require additional explanation typically
  # on the back page of the invoice.
  #
  def page2?
    charge_type.in? [ChargeTypes::GROUND_RENT, ChargeTypes::GARAGE_GROUND_RENT]
  end

  def <=> other
    return nil unless other.is_a?(self.class)

    [date_due, charge_type, amount, period_first, period_last] <=>
      [other.date_due, other.charge_type, other.amount, other.period_first, other.period_last]
  end

  def to_s
    "charge_type: #{charge_type} date_due: #{date_due} " \
    "amount: #{amount.round(2)} " \
    "period: #{period_first}..#{period_last}, " \
    "balance: #{balance ? balance.round(2) : ''}"
  end
end
