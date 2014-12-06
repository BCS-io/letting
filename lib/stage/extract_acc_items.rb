require_relative 'extract'
######
#
# ExtractAccItems
#
# Removes records, array elements, from an array.
#
class ExtractAccItems < Extract
  def match original, extract
    original[:human_ref] == extract[:human_ref] &&
      original[:charge_code] == extract[:charge_code] &&
      original[:on_date] == extract[:on_date]
  end
end
