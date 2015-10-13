require 'rails_helper'
require_relative '../../../lib/import/charge_code'

module DB
  describe ChargeCode, :import do
    describe '.to_string' do
      it 'maps rents' do
        expect(ChargeCode.to_string 'GGR').to eq 'Garage Ground Rent'
      end

      it "maps 'GIns' to garage insurance" do
        expect(ChargeCode.to_string 'GIns').to eq 'Garage Insurance'
      end

      it "maps 'H' to service charge" do
        expect(ChargeCode.to_string 'H').to eq 'Service Charge'
      end

      it "maps 'M' to service charge" do
        expect(ChargeCode.to_string 'M').to eq 'Service Charge'
      end

      it "maps 'Q' to service charge" do
        expect(ChargeCode.to_string 'Q').to eq 'Service Charge'
      end
    end

    describe '.day_month_pairs' do
      it 'GR to 4' do
        expect(ChargeCode.day_month_pairs 'GGR').to eq 4
      end

      it 'converts half yearly to 2' do
        expect(ChargeCode.day_month_pairs 'H').to eq 2
      end

      it 'converts monthly to 1' do
        expect(ChargeCode.day_month_pairs 'M').to eq 1
      end
    end
  end
end
