require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/accounting_row'

####
#
# accounting_row_spec.rb
#
# unit testing for AccoutingRow
#
####
#
module DB
  RSpec.describe AccountingRow, :import do
    let(:accounting) { (Class.new { include AccountingRow }).new }

    describe '#account_id' do
      it 'returns valid' do
        account = account_create property: property_new(human_ref: 89)
        expect(accounting.account(human_ref: 89).id).to eq account.id
      end
      it 'errors invalid' do
        expect { accounting.account.id }.to raise_error PropertyRefUnknown
      end
    end

    describe '#charge_id' do
      it 'returns valid charge_id' do
        charge = charge_new charge_type: 'Rent'
        account = account_create charges: [charge], property: property_new
        expect(accounting.charge(account: account, charge_type: 'Rent'))
          .to eq account.charges.first
      end
      it 'errors if charge unknown' do
        account = account_create property: property_new
        expect { accounting.charge(account: account, charge_type: 'unknown') }
          .to raise_error ChargeUnknown
      end
    end

    describe '#charge_code_to_s' do
      it 'returns valid' do
        property_create human_ref: 89
        expect(accounting.charge_code_to_s(charge_code: 'Ins', human_ref: 89))
          .to eq 'Insurance'
      end

      it 'errors invalid code' do
        property_create human_ref: 89
        expect do
          accounting.charge_code_to_s(charge_code: 'UkwDDn', human_ref: 89)
        end.to raise_error ChargeCodeUnknown
      end
    end
  end
end
