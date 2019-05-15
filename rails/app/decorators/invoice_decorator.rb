require_relative '../../lib/modules/method_missing'
####
#
# InvoiceDecorator
#
# Adds behaviour to the property object
#
# Used when the property has need for behaviour outside of the core
# of the model. Specifically for display information.
#
#
####
#
class InvoiceDecorator
  include DateHelper
  include MethodMissing
  include NumberFormattingHelper
  PAD_TO_LINES = 8

  def invoice
    @source
  end

  def initialize invoice
    @source = invoice
  end

  def invoice_date
    format_short_date invoice.invoice_date
  end

  def billing_agent
    invoice.billing_address.lines.first
  end

  def billing_first_address_line
    invoice.billing_address.lines.second
  end

  #
  # Requirement to have billing address on invoice padded out to PAD_TO_LINES
  # so that invoices remain the same length.
  #
  def billing_address
    invoice.billing_address.lines.in_groups_of(PAD_TO_LINES, "\n ").join
  end

  def products_display
    return 'No charges' if invoice.products.drop_arrears.size.zero?

    invoice.products.drop_arrears.first(2).map do |product|
      "#{product.charge_type} £#{to_decimal product.amount}"
    end.join ', '
  end

  def earliest_date_due
    if invoice.earliest_date_due
      format_short_date invoice.earliest_date_due
    else
      invoice_date
    end
  end
end
