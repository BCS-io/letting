require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/modules/charge_types'
require_relative '../../../lib/import/accounts/balance_row'
include ChargeTypes

####
#
# balance_row_spec.rb
#
# unit testing for debit_row
# rubocop: disable Metrics/ParameterLists
# rubocop: disable Metrics/LineLength
#
####
#
module DB
  describe BalanceRow, :import do
    def row human_ref: 9,
            charge_code: 'GR',
            date: '2012-03-24 00:00:00',
            description: 'Balance',
            amount: 5,
            balance_amount: 5
      BalanceRow.new parse_line \
        %(#{human_ref}, #{charge_code}, #{date}, #{description}, #{amount}, 0, #{balance_amount})
    end

    it 'rows attributes are returned' do
      charge = charge_new charge_type: INSURANCE
      property_create human_ref: 9, account: account_new(charges: [charge])
      row = row(charge_code: 'Ins', amount: 3.05)
      expect(row.attributes[:charge_id]).to eq charge.id
      expect(row.attributes[:at_time]).to eq Time.zone.local(2012, 3, 25, 0, 0, 0)
      expect(row.attributes[:amount]).to eq 3.05
    end

    it 'at_time' do
      expect(row(date: '2012-03-20 00:00:00').at_time)
        .to eq Time.zone.local(2012, 3, 20, 0, 0, 0)
    end

    it 'creates datetime period' do
      expect(row(date: '2012-03-20 00:00:00').period)
        .to eq Date.new(2000, 1, 1)..Date.new(2012, 3, 20)
    end

    describe 'methods' do
      describe 'charge_type' do
        context 'balance with description' do
          it 'returns charge_type' do
            spec_row = row charge_code: 'Bal',
                           description: 'Balance Service Charge'
            expect(spec_row.charge_type).to eq 'Service Charge'
          end
        end
        context 'balance with charge code' do
          it 'returns charge_type' do
            spec_row = row(charge_code: 'GR')
            expect(spec_row.charge_type).to eq 'Ground Rent'
          end
        end

        context 'uses description to find charge' do
          it 'returns ' do
            spec_row = row(charge_code: 'Bal', description: 'Balance Service Charge')
            expect(spec_row.charge_type).to eq 'Service Charge'
          end
          it 'returns ' do
            spec_row = row(charge_code: 'Bal', description: 'Service Charge 2012/13')
            expect(spec_row.charge_type).to eq 'Service Charge'
          end
        end
      end

      describe '#next_at_time' do
        it 'finds next at_time' do
          cycle = cycle_new(due_ons: [DueOn.new(month: 4, day: 1)])
          charge = charge_new charge_type: GROUND_RENT,
                              cycle: cycle
          property_create human_ref: 9, account: account_new(charges: [charge])

          expect(row.next_at_time).to eq Time.zone.local(2012, 4, 1, 0, 0, 0)
        end

        it 'finds next at_time even if same as due_date' do
          cycle = cycle_new(due_ons: [DueOn.new(month: 3, day: 24)])
          charge = charge_new charge_type: GROUND_RENT,
                              cycle: cycle
          property_create human_ref: 9, account: account_new(charges: [charge])

          expect(row.next_at_time).to eq Time.zone.local(2012, 3, 24, 0, 0, 0)
        end
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: ->(field) { field ? field.strip : nil })
    end
  end
end
