require 'csv'
require 'rails_helper'
require_relative '../../../../lib/import/charges/legacy_charged_in_fields'
require_relative '../../../../lib/modules/charge_types'
include ChargeTypes

####
#
# legacy_charged_in_fields_spec.rb
#
# unit testing for charged_in_fields
#
# LegacyChargedInFields wraps up fields from acc_info.csv rows
# - used by ImportCharge - fed into ChargeRow which initializes
# LegacyChargedInFields
#
####
module DB
  include ChargedInDefaults
  RSpec.describe LegacyChargedInFields, :import do
    describe '#id' do
      context 'valid legacy code' do
        it 'returns charged_in code' do
          charged = LegacyChargedInFields.new charged_in_code: LEGACY_ARREARS,
                                              charge_type: 'unknown'
          expect(charged.modern_id).to eq MODERN_ARREARS
        end

        it 'returns arrears when charged_in_code mid-term' do
          charged = LegacyChargedInFields.new charged_in_code: LEGACY_MID_TERM,
                                              charge_type: 'unknown'
          expect(charged.modern_id).to eq MODERN_ARREARS
        end

        it 'returns charge_type code over charged_in_code' do
          charged = LegacyChargedInFields
                    .new charged_in_code: LEGACY_ARREARS,
                         charge_type: INSURANCE
          expect(charged.modern_id).to eq MODERN_ADVANCE
        end
      end
      context 'invalid legacy code' do
        it 'errors when invalid code and unknown charge_type' do
          bad_charged = LegacyChargedInFields.new charged_in_code: 'U',
                                                  charge_type: 'unknown'
          expect { bad_charged.modern_id }.to raise_error KeyError
        end

        it 'returns charge_type code over charged_in_code' do
          charged = LegacyChargedInFields.new charged_in_code: 'U',
                                              charge_type: INSURANCE
          expect(charged.modern_id).to eq MODERN_ADVANCE
        end
      end
    end
  end
end
