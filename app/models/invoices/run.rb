####
#
# Run
#
# Each Invoicing is normally printed twice.
# Between runs the debits won't change but the payments will.
# Each run updates the payments, credits, which in turn affects the outputted
# invoice.
#
####
#
class Run < ActiveRecord::Base
  belongs_to :invoicing, inverse_of: :runs
  has_many :invoices, dependent: :destroy, inverse_of: :run

  validates :invoice_date, :invoices, presence: true
  after_initialize :init

  #
  # prepare
  # assigns required attributes and create the invoices required for invoice
  #
  # invoice_date - date to appear on the invoice
  #
  def prepare(invoices_maker:)
    self.invoice_date = invoice_date
    self.invoices = invoices_maker.invoices
  end

  #
  # actionable?
  # Are the accounts invoiceable?
  # prepare must be called before actionable will return correct result
  #
  def actionable?
    invoices.select(&:actionable?).present?
  end

  def deliver
    invoices.select(&:deliver)
  end

  def retain
    invoices.select { |invoice| invoice.deliver == false }
  end

  def finished?
    invoices.present?
  end

  private

  def init
    self.invoice_date = Time.zone.today if invoice_date.blank?
  end
end
