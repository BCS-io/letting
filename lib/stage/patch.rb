####
#
# Patch
#
# Updating data which is incorrect. It overwrites original
# rows with patch rows as required.
#
# Patch is part of the staging process - specifically it is called by
# all of the stage/*.rake tasks.
#
#
####
#
class Patch
  attr_reader :patch

  # args
  #   patch - the corrected rows
  #
  def initialize(patch:)
    @patch = patch
  end

  # cleanse
  #   - replacing an incorrect row with a patched row.
  # args
  #   originals - the unchanged rows
  #
  # returns
  #   original row if no match is found
  #   patched row if a match is found
  #
  # TODO: should be returning a copy of the array not altering
  # the passed in array.
  #
  #
  def cleanse(originals:)
    originals.map! do |original|
      stand_in(original) || original
    end
  end

  def match _original, _patch
    warn 'override match method'
    false
  end

  # stand_in
  #  - returns the replacement row, if any
  # args
  #   original - unchanged row
  # returns
  #   replacement row if found
  #   nil if no match
  def stand_in(original)
    patch.find { |patch| match original, patch }
  end
end
