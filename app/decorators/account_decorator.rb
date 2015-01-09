require_relative '../../lib/modules/method_missing'

####
#
# AccountDecorator
#
# AccountDecorator prepares credits and debits and allows them
# to be viewed
#
# rubocop: disable Style/TrivialAccessors
####
#
class AccountDecorator
  include MethodMissing

  def account
    @source
  end

  def initialize account
    @source = account
  end

  # All Transactions
  #
  def all_items
    running_balance dec_items
  end

  # This year Transactions
  #
  def abbrev_items
    running_balance [forward_balance(start_of_year)] +
      dec_items.select { |item| item.on_date >= start_of_year }
  end

  private

  def start_of_year
    @start_of_year ||= Time.zone.local(Time.zone.now.year, 1, 1)
  end

  def forward_balance time_of
    AccountBalanceDecorator.new(account.balance(to_time: time_of), time_of)
  end

  def dec_items
    [*account.debits.map { |debit| AccountDebitDecorator.new debit },
     *account.credits.map { |credit| AccountCreditDecorator.new credit }]
      .sort_by(&:on_date)
  end

  # Assigns a running_balance attribute to the credit / debit item
  #
  def running_balance items
    running_balance = 0
    items.map do |item|
      item.running_balance = running_balance += item.balance
      item
    end
  end
end
