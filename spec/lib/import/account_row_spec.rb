require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/account_row'

####
# AccountRow Spec
#
# Testing the import of Account rows.
#
# rubocop: disable  Metrics/ParameterLists
# rubocop: disable  Metrics/LineLength
####
module DB
  describe AccountRow, :import do
    def row human_ref: 9,
            charge_code: 'GR',
            date: '2012-03-25',
            credit_amount: 5.5,
            description: ChargeTypes::GROUND_RENT,
            debit_amount: 0
      AccountRow.new parse_line \
        %(#{human_ref}, #{charge_code}, #{date}, #{description}, #{debit_amount}, #{credit_amount}, 0)
    end

    describe 'attributes' do
      it('human_ref') { expect(row(human_ref: 7).human_ref).to eq 7 }
    end

    describe 'methods' do
      describe '#type' do
        it 'returns credit when credit' do
          expect(row(credit_amount: 1, debit_amount: 0).type).to eq 'credit'
        end
        it 'returns debit when debit' do
          expect(row(credit_amount: 0, debit_amount: 1).type).to eq 'debit'
        end
        it 'returns debit when negative credit' do
          expect(row(credit_amount: -1, debit_amount: 0).type).to eq 'debit'
        end
        it 'returns balance when charge code has balance' do
          expect(row(charge_code: 'Bal').type).to eq 'balance'
        end
        it 'returns balance when description has balance' do
          expect(row(description: 'Balance').type).to eq 'balance'
        end

        it 'error if row type unknown' do
          property_create(human_ref: 9,
                          account: account_new(charges: [charge_new]))
          expect { row(charge_code: 'XX', credit_amount: 0, debit_amount: 0).type }
            .to raise_error AccountRowTypeUnknown, \
                            'Unknown Row Property:9, charge_code: XX'
        end
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil })
    end
  end
end
