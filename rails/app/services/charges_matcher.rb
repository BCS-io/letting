require_relative '../../lib/import/errors'
####
#
# ChargesMatcher
#
# Matching only needed during the import process
#
# This is a service object for Charges it allows a charge to match
# an imported charge. Matching import charges should not be the concern
# of the Charge object. The import process will happen until the migration
# to the new system is complete - the import code is then retired.
#
####
#
class ChargesMatcher
  attr_reader :charges

  def initialize charges
    @charges = charges
  end

  def first_or_initialize charge_type
    find(charge_type) || charges.build
  end

  delegate :size, to: :charges

  private

  def find charge_type
    charges.find { |charge| charge.charge_type == charge_type }
  end
end
