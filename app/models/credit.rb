####
#
# Credit
#
# Generated by payments and linked to a debit. The credit offsets
# a debit charged to a property account.
#
#
# A payment is applied to one property account. When being applied
# it finds unpaid debts and generates a matching credit.
# The credits get set during the payments controller #create action.
#
####
#
class Credit < ActiveRecord::Base
  belongs_to :payment
  belongs_to :account
  belongs_to :debit, inverse_of: :credits

  validates :on_date, presence: true
  validates :amount, amount: true
  validates :amount, numericality: { less_than_or_equal_to: ->(credit) { credit.maximum_payment } }

  after_initialize do |debit_generator|
    self.on_date = default_on_date if on_date.blank?
    self.amount = outstanding if amount.blank?
  end

  def self.search(search)
    @accounts = Accounts.find_by_property_id params[:property]
  end

  def outstanding
    debit.outstanding
  end

  def maximum_payment
    new_record? ? outstanding : outstanding + amount
  end

  private

  def default_on_date
    Date.current
  end

end
