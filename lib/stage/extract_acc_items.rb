require_relative 'extract'
######
#
# ExtractAccItems
#
# Removes records, array elements, from an array.
#
# Uses lib/stage/extract
####
#
class ExtractAccItems < Extract
  def match original, extract
    original[:human_ref] == extract[:human_ref] &&
      original[:charge_code] == extract[:charge_code] &&
      original[:at_time] == extract[:at_time]
  end
end
