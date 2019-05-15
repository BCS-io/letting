require_relative 'insert'
####
#
# Insert
#
# adding data which are missing. It applies them into the correct position.
#
# Insert is part of the staging process - specifically it is called by
# all of the stage/*.rake tasks.
#
# Uses lib/stage/insert
#
####
#
class InsertAccInfo < Insert
  def sort originals
    originals.sort_by! { |item| [item[:human_ref].to_i, item[:charge_type]] }
  end
end
