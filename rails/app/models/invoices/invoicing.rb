
####
#
# Invoicing
#
# A batch of invoices to bill customers.
#
# The user searches for property-ids within a date range that will be billed.
# InvoicesMaker returns invoices that are to be debited during the invoicing
# period.
#
# An invoice is the information required to print an invoice. Made up of
# property related information and the products (services) that are charged
# during the time period of the invoice.
#
class Invoicing < ApplicationRecord
  WEEKS_AHEAD = 7
  has_many :runs, dependent: :destroy, inverse_of: :invoicing

  validates :property_range, :period_first, :period_last, :runs, presence: true
  validate :validate_mininum_accounts
  validate :validate_run

  scope :by_period_and_created_at, -> { order(period_first: :desc, created_at: :desc) }
  scope :blue_invoicies, -> { where('runs_count = 1') }

  # period
  #  - returns the date range which the invoicing covers
  #
  def period
    (period_first..period_last)
  end

  # period=(billing_date)
  #  - set billing date period covered by the invoicing
  #
  def period=(billing_dates)
    self.period_first = billing_dates.first
    self.period_last  = billing_dates.last
  end

  after_initialize :init
  def init
    self.period_first = Time.zone.today if period_first.blank?
    self.period_last = Time.zone.today + WEEKS_AHEAD.weeks if period_last.blank?
  end

  # converts property_range into account objects.
  #
  def accounts
    AccountFinder.new(property_range: property_range).matching
  end

  # actionable?
  # Would this invoicing create an invoice at all?
  #
  def actionable?
    runs.present? && runs.last.actionable?
  end

  # deliverable?
  # Anything to print?
  #
  def deliverable?
    return false if runs.blank?

    runs.last.deliverable?
  end

  # generate
  # makes a run - assigning the invoices given the invoicing arguments.
  #
  def generate(invoice_date: Time.zone.today, comments: [])
    runs.build.prepare invoices_maker: invoices_maker(invoice_date, comments)
    self
  end

  # valid_arguments?
  # Does this invoicing have enough arguments to call generate on?
  # Nil values for property_range and period are nil cause problems.
  #
  def valid_arguments?
    property_range && period.first && period.last
  end

  private

  def invoices_maker invoice_date, comments
    InvoicesMaker.new invoicing: self,
                      color: color,
                      invoice_date: invoice_date,
                      comments: comments
  end

  # note:
  # size works with memory loaded vs count which is the database count
  #
  def color
    runs.size <= 1 ? :blue : :red
  end

  # custom validation that there are accounts that cover the invoicing date period
  # returns
  #   - true if there are accounts which are covered by the invoicing
  #   - otherwise adds error to the error object
  #
  def validate_mininum_accounts
    return true unless accounts.empty?

    errors.add(:invoice_accounts, 'does not match any accounts.')
  end

  # custom validation that at least one account can be charged for the period
  # returns
  #  - true if valid run
  #  - otherwise adds error to the error object
  #
  def validate_run
    return true if actionable?

    return true if property_range.blank? # blank covered by presence

    errors.add(:property_range,
               ", #{property_range}, has no account that can" \
               " be charged for the period #{period.first} to #{period.last}.")
  end
end
