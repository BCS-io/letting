####
#
# Credit
#
# Generated by payments and linked to a debit. The credit offsets
# a debit charged to a property account.
#
#
# A payment is applied to one property account. When being applied
# it finds unpaid debits and generates a matching credit.
# The credits get set during the payments controller #create action.
#
# Credits decrease an accounts balance -.
####
#
class Credit < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :charge
  has_many :debits, through: :settlements
  has_many :settlements, dependent: :destroy

  validates :charge_id, :on_date, presence: true
  validates :amount, credit: true
  before_save :reconcile

  after_initialize do
    self.on_date = Date.current if on_date.blank?
  end

  delegate :charge_type, to: :charge

  def clear_up
    mark_for_destruction if amount.nil? || amount.round(2) == 0
  end

  # outstanding is the amount left unpaid
  # (credit) amount is normally negative
  # settled starts at 0 and becomes larger until settled - amount == 0
  # Outstanding will be initally negative trending to 0
  def outstanding
    -amount - settled
  end

  def spent?
    outstanding.round(2) == 0.00
  end

  def reverse
    self.amount *= -1
  end

  # charge_id - the charge you are querying for unspent credits.
  # returns - the unspent credits for the charge_id
  #
  def self.available charge_id
    where(charge_id: charge_id).order(:on_date).reject(&:spent?)
  end

  private

  def reconcile
    Settlement.resolve(outstanding, Debit.available(charge_id)) do |offset, pay|
      settlements.build debit: offset, amount: pay
    end
  end

  def settled
    settlements.pluck(:amount).inject(0, :+)
  end
end
