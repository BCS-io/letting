###################
#
# AccountsDebits
#
# Ideally this should be an SQL statement. However, the due dates are held as
# month, day combinations which makes doing SQL queries tricky.
#
#
class AccountsDebits
  attr_reader :property_range, :debit_period
  def initialize(property_range:, debit_period:)
    @property_range = property_range
    @debit_period = debit_period
  end

  def list
    @list ||= Hash[make.sort]
  end

  private

  def accounts
    Account.between?(property_range)
  end

  def make
    made = Hash.new { [] }
    accounts.each do |account|
      make_account_debits(account).each do |account_debit|
        mix collection: made, includee: account_debit
      end
    end
    made
  end

  # Add a element into a collection
  # If key present, we merge it to the already present key's value
  # Else, if not present, we assign it to the collection under the unknown key.
  #
  def mix(collection:, includee:)
    if collection.key? includee.key
      collection[includee.key].merge includee
    else
      collection[includee.key] = includee
    end
  end

  def make_account_debits account
    account.debits_coming(debit_period).map do |debit|
      AccountDebit.new(date_due: debit.at_time.to_date,
                       charge_type: debit.charge_type,
                       property_ref: account.property.human_ref,
                       amount: debit.amount)
    end
  end
end
