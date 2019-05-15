####
#
# Insert
#
# adding data which are missing. It applies them into the correct position.
#
# Insert is part of the staging process - specifically it is called by
# all of the stage/*.rake tasks.
#
####
#
class Insert
  attr_reader :insert
  def initialize(insert:)
    @insert = insert
  end

  def cleanse(originals:)
    originals.concat insert
    sort originals
  end

  def sort _originals
    warn 'override sort method'
  end
end
