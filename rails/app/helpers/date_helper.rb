require_relative '../../lib/modules/salient_date'

####
#
# DateHelper
#
# Shared helper for dates
#
####
#
module DateHelper
  include ActionView::Helpers::NumberHelper
  include SalientDate

  def format_date date
    I18n.l date, format: :human
  end

  def format_short_date date
    I18n.l date, format: :short
  end
end
