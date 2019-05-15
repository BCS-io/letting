###
#
# ChargedInDefaults
#
# Constants relating to ChargedIn
# Most charges are in Advance or Arrears - Mid-term is only used in
# the legacy application it was a charge that was due around half way
# into the service period.
#
# LEGACY = the previous application
# MODERN = this application
#
####
module ChargedInDefaults
  LEGACY_ARREARS = '0'.freeze
  LEGACY_ADVANCE = '1'.freeze
  LEGACY_MID_TERM = 'M'.freeze

  MODERN_ARREARS = 'arrears'.freeze
  MODERN_ADVANCE = 'advance'.freeze
end
