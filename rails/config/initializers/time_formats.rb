Date::DATE_FORMATS[:day_and_month] = lambda do |date|
  date.strftime("#{date.day.ordinalize} %b")
end
