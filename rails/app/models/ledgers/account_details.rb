#
# AccountDetails
#
# SQL View onto Database - the table is a union of credits and debits.
#
#
class AccountDetails < ApplicationRecord
  belongs_to :account
  belongs_to :property

  #
  # Accounts that were balanced a time ago
  #
  # at_time: the time when we see if an account was balanced
  # returns accounts that were balanced.
  #
  def self.balanced at_time: (Time.zone.now - 2.years).to_date
    AccountDetails.select('account_id, property_id')
                  .where('at_time < ?', at_time)
                  .group(:account_id, :property_id, :human_ref)
                  .having('Sum(amount) = 0')
                  .order(:human_ref)
  end

  # self.balance_all
  #  - returns accounts with balances greater than arg
  #
  #  argument
  #  - greater_than: 0  - balance needed to be greater than
  #
  # returns
  #  - information about accounts owing over greater_than
  #
  def self.balance_all greater_than: 0
    AccountDetails.includes(property: %i[client address entities])
                  .select('account_id, property_id, sum(amount) as amount')
                  .group(:account_id, :property_id, :human_ref)
                  .having('Sum(amount) >= ?', greater_than)
                  .order(:human_ref)
  end
end
