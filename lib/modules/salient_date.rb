#
# SalientDate
# Return the amount of the date that we need to distinguish
# Example if both dates are in this year - leave off the date
#
module SalientDate
  def salient_date_range(start_date:, end_date:)
    if start_date && end_date &&
       start_date.year == Time.zone.today.year &&
       end_date.year == Time.zone.today.year &&
       start_date.year == end_date.year
      "#{safe_date(date: start_date, format: :month_date)} - "\
      "#{safe_date(date: end_date, format: :month_date)}"
    else
      "#{safe_date(date: start_date, format: :short)} - "\
      "#{safe_date(date: end_date, format: :short)}"
    end
  end

  def safe_date(date:, format:)
    return '' unless date
    "#{I18n.l date, format: format}"
  end
end
