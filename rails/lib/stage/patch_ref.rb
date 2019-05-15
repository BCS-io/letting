require_relative 'patch'

####
#
# PatchRef
#
# Updating data which is incorrect. It matches by human_ref used
# in a number of the import files: property, client and address2.
#
# PatchRef is part of the staging process - specifically it is called by
# address2.rake, clients.rake, properties.rake
#
####
#
class PatchRef < Patch
  def match original, patch
    original[:human_ref] == patch[:human_ref]
  end
end
