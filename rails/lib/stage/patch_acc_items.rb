require_relative 'patch'

####
#
# PatchAccItems
#
# Updating accounts/charges which are incorrect. It overwrites charge
# rows with patch rows as required.
#
# PatchAccItems is part of the staging process - specifically it is called by
# acc_info.rake
#
####
#
class PatchAccItems < Patch
  def match original, patch
    original[:human_ref] == patch[:human_ref] &&
      original[:charge_type] == patch[:charge_type] &&
      original[:at_time] == patch[:at_time]
  end
end
