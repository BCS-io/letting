####
#
# Extract
#
# Removing data - matching rows are deleted and removed from the staging
# process.
#
# Extract is part of the staging process - specifically it is called by
# all of the stage/*.rake tasks.
#
####
#
class Extract
  attr_reader :extracts
  def initialize(extracts:)
    @extracts = extracts
  end

  def cleanse(originals:)
    extracts.map! do |extract|
      originals.delete_if { |original| match original, extract }
    end
  end

  def match _original, _extract
    warn 'override match method'
    false
  end
end
