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
####
#
class InvoicingIndexDecorator
  include DateHelper
  include SalientDate
  include MethodMissing

  def invoicing
    @source
  end

  def initialize invoicing
    @source = invoicing
  end

  def created_at
    format_date invoicing.created_at
  end

  def period_between
    salient_date_range start_date: invoicing.period_first,
                       end_date: invoicing.period_last
  end
end
