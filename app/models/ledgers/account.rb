####
#
# The Account is a summation of charges, debits, and credits on a property.
#
# The account has one property. A property has a number of charges.
# The charges generate debits and payments create credits that cover
# these debits.
#
# Balance
# Debits increase an accounts balance +.
# Credits decrease an accounts balance -.
#
# Definition
#
# Accounts
# Receivable - money owed by customer for a service that has been delivered
#              but not paid for.
# Associations
# Provides queries for account records - required by Payment and debits.
#
# rubocop: disable Metrics/MethodLength, Metrics/LineLength
#
####
#
class Account < ActiveRecord::Base
  belongs_to :property, inverse_of: :account
  def holder
    property.occupiers
  end

  has_many :payments, dependent: :destroy, inverse_of: :account
  has_many :credits, dependent: :destroy
  has_many :debits, dependent: :destroy, inverse_of: :account do
    def exclusive? query_debit
      self.any? { |debit| debit.like? query_debit }
    end
  end
  accepts_nested_attributes_for :debits, allow_destroy: true
  has_many :snapshots, dependent: :destroy, inverse_of: :account

  MAX_CHARGES = 6
  has_many :charges, dependent: :destroy do
    def prepare
      (size...MAX_CHARGES).each { build }
      each(&:prepare)
    end

    def clear_up_form
      each(&:clear_up_form)
    end
  end
  validate :maximum_charges
  def maximum_charges
    return if charges.blank?

    errors.add(:charges, 'Too many charges') if charges.size > MAX_CHARGES
  end
  accepts_nested_attributes_for :charges, allow_destroy: true

  # accounting_period - the date range that we generate debits for.
  # returns        - debits array with data required to bill the
  #                  associated account.
  def debits_coming accounting_period
    debits = []
    charges.each do |charge|
      charge.coming(accounting_period).map do |chargeable|
        debits << Debit.new(chargeable.to_hash)
      end
    end
    debits
  end

  # Create the credits from the account's charges
  #
  def make_credits
    charges.map { |charge| create_credit charge }
  end

  def exclusive(query_debits:)
    query_debits.reject { |query_debit| debits.exclusive? query_debit }
  end

  def prepare_for_form
    charges.prepare
  end

  delegate :clear_up_form, to: :charges

  def balance to_time: Time.zone.today
    debits.until(to_time).total - credits.until(to_time).total
  end

  # Query to return significant balances for all accounts
  # greater_than - level above which we return accounts.
  #
  def self.balance_all greater_than: 0
    # Coalesce require if you want to see accounts with 0 balances
    #
    query = <<-SQL
      SELECT id, property_id, sum(amount) as amount FROM (
        SELECT accounts.id, property_id, coalesce(credits.amount * -1, 0) as amount
        FROM "accounts"
        LEFT JOIN credits ON credits.account_id = accounts.id
        UNION
        SELECT accounts.id, property_id, coalesce(debits.amount, 0) as amount
        FROM "accounts"
        LEFT JOIN debits ON debits.account_id = accounts.id
      ) t
      GROUP BY id, property_id
      HAVING sum(amount) > ?
      ORDER BY id
    SQL
    find_by_sql [query, greater_than]
  end

  # Finds and returns a matching Account
  # human_ref - account reference number, '2002'
  #
  def self.find_by_human_ref human_ref
    Account.between?(human_ref).first
  end

  # Searches for matching accounts human_ref between a range
  # query - an account or account range, '2002 - 3000'
  #
  def self.between? human_ref_range
    return Account.none if human_ref_range.nil?
    human_refs = human_ref_range.split('-')
    human_refs << human_refs.first if human_refs.size == 1
    Account.includes(:property)
      .where(properties: { human_ref: human_refs[0]..human_refs[1] })
      .order('properties.human_ref')
  end

  private

  def create_credit charge
    credits.build charge: charge,
                  at_time: Time.zone.today,
                  amount: charge.amount
  end
end
