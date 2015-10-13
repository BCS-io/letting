###
# ProductDecorator
#
# Adds display logic to the product business object used by invoice_page1
# to output the data for an invoice.
#
##
#
class ProductDecorator
  include MethodMissing
  include DateHelper
  include NumberFormattingHelper

  def product
    @source
  end

  def initialize source_product
    @source = source_product
  end

  def date_due
    format_short_date product.date_due
  end

  def period
    return '&nbsp;'.html_safe unless product.period.first && product.period.last
    "#{format_short_date product.period.first} - "\
    "#{format_short_date product.period.last}"
  end

  def amount
    to_decimal product.amount
  end

  def amount_on_time
    "£#{amount} on #{date_due}"
  end

  def balance
    to_decimal product.balance
  end
end
