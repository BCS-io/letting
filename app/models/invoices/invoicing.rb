
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
class Invoicing < ActiveRecord::Base
  WEEKS_AHEAD = 7
  has_many :runs, dependent: :destroy, inverse_of: :invoicing
  validates :property_range, :period_first, :period_last, :runs, presence: true
  scope :default, -> { order(period_first: :desc) }
  scope :blue_invoicies, -> { where('runs_count = 1') }

  def period
    (period_first..period_last)
  end

  def period=(billing)
    self.period_first = billing.first
    self.period_last  = billing.last
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

  validate :mininum_accounts
  def mininum_accounts
    return unless accounts.empty?

    errors.add(:invoice_accounts, 'does not match any accounts.')
  end

  validate :valid_run
  def valid_run
    return if actionable?

    return if property_range.blank? # blank covered by presence
    errors.add(:property_range,
               ", #{property_range}, has no account that can" \
               " be charged for the period #{period.first} to #{period.last}.")
  end

  # valid_arguments?
  # Does this invoicing have enough arguments to call generate on?
  # Nil values for property_range and period are nil cause problems.
  #
  def valid_arguments?
    property_range && period.first && period.last
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
    return false unless runs.present?

    runs.last.deliverable?
  end

  # generate
  # makes a run - assigning the invoices given the invoicing arguments.
  #
  def generate(invoice_date: Time.zone.today, comments: [])
    runs.build.prepare invoices_maker: invoices_maker(invoice_date, comments)
    self
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
end
