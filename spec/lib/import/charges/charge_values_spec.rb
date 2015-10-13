require 'rails_helper'
require_relative '../../../../lib/import/charges/charge_values'

module DB
  describe ChargeValues, :import do
    context 'Converts from code' do
      it 'returns a ChargeValues' do
        charge_value = ChargeValues.from_code 'GGR'
        expect(charge_value.charge_code).to eq 'Garage Ground Rent'
      end

      it 'returns a max number of dates per year' do
        charge_value = ChargeValues.from_code 'GGR'
        expect(charge_value.max_dates_per_year).to eq 4
      end
    end
  end
end
