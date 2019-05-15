require_relative 'patch'

####
#
# PatchAccInfo
#
# Updating accounts/charges which are incorrect. It overwrites charge
# rows with patch rows as required.
#
# PatchAccInfo is part of the staging process - specifically it is called by
# acc_info.rake
#
####
#
class PatchAccInfo < Patch
  def match original, patch
    original[:human_ref] == patch[:human_ref] &&
      original[:charge_type] == patch[:charge_type]
  end
end
