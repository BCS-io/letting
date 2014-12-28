# Invoice Requires
#
# Agent
# - Compound Name and address
# Property Ref
# Invoice Date
# Property Address
# Arrears
#  - balance on the account on that day
#
# Invoice item
#   - Charge Type
#   - Date Due
#   - Description
#   - Amount
#   - Balance
#   - Time Period the charge covers
#
# - Total Owing
#
# Client
#   - Compound Name and address
#
# TODO: remove MethodLength and ParameterLists errors
# rubocop: disable Metrics/MethodLength, Metrics/ParameterLists
#
class Invoice < ActiveRecord::Base
  enum deliver: [:mail, :retain]
  belongs_to :run, inverse_of: :invoices
  belongs_to :snapshot, autosave: true, inverse_of: :invoices
  has_many :comments, dependent: :destroy
  has_many :products, -> { order(:created_at) }, dependent: :destroy, inverse_of: :invoice do # rubocop: disable Metrics/LineLength
    def earliest_date_due
      map(&:date_due).min
    end

    def balanced
      total = 0 # if product != 0 then the first product is the balance.
      each_with_index do |product, _index|
        product.balance = total += product.amount
        product
      end
    end

    def drop_arrears
      reject { |product| product.charge_type == 'Arrears' }
    end

    def total_arrears
      return 0 if last.nil?

      last.balance
    end
  end
  validates :invoice_date, :property_ref, :property_address, presence: true
  has_many :invoice_texts, through: :letters
  has_many :letters, dependent: :destroy

  after_destroy :destroy_orphaned_snapshot

  delegate :earliest_date_due, to: :products

  def total_arrears
    products.balanced
    products.total_arrears
  end

  # prepare
  # Assigns the attributes required in an invoice
  # Args:
  # account            - account invoice is being prepared for
  # invoice_date       - the date which this invoice is being said to have been
  #                      sent.
  # property           - property that the invoice is being prepared for
  # snapshot - a transaction made up of the debits that will be added
  #                      to the invoice
  # comments           - array of strings to appear on invoice for special info.
  #
  def prepare(invoice_date: Time.zone.today,
              property:,
              snapshot:,
              comments: [])
    self.invoice_date = invoice_date
    letters.build invoice_text: InvoiceText.first
    self.property = property
    self.comments = generate_comments comments: comments
    self.snapshot = snapshot

    self.products = snapshot.products invoice_date: invoice_date
    self
  end

  def page2?
    blue_invoice? && products.any?(&:page2?)
  end

  # actionable?
  # Is it worth printing out an invoice for this record?
  # products have to be created before this method returns expected values
  #
  def actionable?
    products.balanced
    products.total_arrears > 0
  end

  def property
    {
      property_ref: property_ref,
      occupiers: occupiers,
      property_address: property_address,
      billing_address: billing_address,
      client_address: client_address,
    }
  end

  def to_s
    "Billing Address: #{billing_address.inspect}\n"\
    "Property Ref: #{property_ref.inspect}\n"\
    "Invoice Date: #{invoice_date.inspect}\n"\
    "Property Address: #{property_address.inspect}\n"\
    "client: #{client_address.inspect}"
  end

  private

  def property=(property_ref:, occupiers:, property_address:, billing_address:, client_address:) # rubocop: disable Metrics/LineLength
    self.property_ref = property_ref
    self.occupiers = occupiers
    self.property_address = property_address
    self.billing_address = billing_address
    self.client_address = client_address
  end

  def destroy_orphaned_snapshot
    snapshot.invoices.empty? && snapshot.destroy
  end

  def blue_invoice?
    snapshot.only_one_invoice?
  end

  def generate_comments(comments:)
    comments.reject(&:blank?).map { |comment| Comment.new clarify: comment }
  end
end
