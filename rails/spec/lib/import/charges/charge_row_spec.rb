require 'csv'
require 'rails_helper'
require_relative '../../../../lib/import/file_header'
require_relative '../../../../lib/import/charges/charge_row'
require_relative '../../../../lib/import/charges/due_on_importable'
# rubocop: disable Metrics/ModuleLength

####
#
# charge_row_spec.rb
#
# unit testing for charge_row
#
# ChargeRow wraps up acc_info.csv rows - used by ImportCharge
#
# rubocop: disable Metrics/ParameterLists
#
####
module DB
  include ChargedInDefaults
  RSpec.describe ChargeRow, :import do
    def charge_row code: 'GR',
                   charged_in: 0,
                   amount: 50.5,
                   month_1: 3,
                   day_1: 25,
                   month_2: 0,
                   day_2: 0
      %(89, 2006-12-30, #{code}, #{charged_in}, #{amount}, S,) +
        %(#{day_1}, #{month_1}, #{day_2}, #{month_2}, 0, 0, 0, 0,) +
        %(1901-01-01, 0)
    end
    describe 'attribute' do
      it 'amount' do
        expect(ChargeRow.new(parse_line charge_row).amount).to eq 50.5
      end
    end

    describe 'methods' do
      describe '#charge_type' do
        it 'returns' do
          expect(ChargeRow.new(parse_line charge_row).charge_type)
            .to eq 'Ground Rent'
        end
        it 'errors invalid' do
          bad_type = ChargeRow.new parse_line charge_row code: 'BAD'
          expect { bad_type.charge_type }.to raise_error ChargeCodeUnknown
        end
      end

      describe '#charged_in' do
        it 'returns valid id' do
          row = charge_row(charged_in: 0)
          expect(ChargeRow.new(parse_line row).charged_in)
            .to eq MODERN_ARREARS
        end

        # insurance must have an advance charged_in - think about it ;-)
        it 'overrides when charge must be in advance' do
          row = ChargeRow.new parse_line charge_row(code: 'Ins', charged_in: 0)
          expect(row.charged_in).to eq MODERN_ADVANCE
        end

        it 'overrides due_on when charged_in is Mid-term' do
          row = charge_row charged_in: LEGACY_MID_TERM
          expect(ChargeRow.new(parse_line row).day_months)
            .to eq [DueOnImportable.new(3, 25, 6, 24),
                    DueOnImportable.new(9, 29, 12, 25)]
        end

        it 'errors on invalid' do
          row = ChargeRow.new parse_line charge_row(charged_in: 'BAD')
          expect { row.charged_in }.to raise_error ChargedInCodeUnknown
        end
      end

      describe '#cycle_id' do
        it 'returns valid id' do
          cycle_create id: 3,
                       charged_in: MODERN_ARREARS,
                       due_ons: [DueOn.new(month: 3, day: 25)]
          row = ChargeRow.new parse_line \
            charge_row charged_in: LEGACY_ARREARS,
                       month_1: 3,
                       day_1: 25
          expect(row.cycle_id).to eq 3
        end

        it 'returns valid mid_term id' do
          cycle_create \
            id: 3,
            charged_in: MODERN_ARREARS,
            due_ons: [DueOn.new(month: 3, day: 25, show_month: 6, show_day: 24),
                      DueOn.new(month: 9, day: 29, show_month: 12, show_day: 12)]
          row = ChargeRow.new parse_line \
            charge_row charged_in: LEGACY_MID_TERM,
                       # Legacy data uses wrong dates
                       # we continue this practice
                       month_1: 6,  day_1: 24,
                       month_2: 12, day_2: 25
          expect(row.cycle_id).to eq 3
        end

        it 'messages when no cycles' do
          row = ChargeRow.new parse_line charge_row month_1: 3, day_1: 25
          expect { warn 'Cycle table has no records' }.to output.to_stderr
          row.cycle_id
        end

        it 'messages on unknown cycle dates' do
          cycle_create id: 3,
                       charged_in: MODERN_ADVANCE,
                       due_ons: [DueOn.new(month: 10, day: 10)]
          row = ChargeRow.new parse_line charge_row \
            charged_in: LEGACY_ARREARS,
            month_1: 3,
            day_1: 25
          expect { warn 'charge row does not match a cycle' }
            .to output.to_stderr
          row.cycle_id
        end

        it 'messages on unknown charged_in' do
          cycle_create id: 3,
                       charged_in: MODERN_ARREARS,
                       due_ons: [DueOn.new(month: 3, day: 25)]
          row = ChargeRow.new parse_line charge_row \
            charged_in: 'UNKNOWN',
            month_1: 3,
            day_1: 25
          expect { row.cycle_id }.to raise_error DB::ChargedInCodeUnknown
        end
      end

      describe '#day_months' do
        it 'creates day and months' do
          row = ChargeRow.new parse_line charge_row month_1: 3, day_1: 25
          expect(row.day_months).to eq [DueOnImportable.new(3, 25)]
        end

        describe 'produces day month pairs' do
          it 'stops on empty due date (0,0)' do
            charge_row = %q(9,, GR, 0, 5.5, S, 1, 1, 0, 0, 0, 0, 0, 0,, 0)
            expect(ChargeRow.new(parse_line(charge_row)).day_months.count)
              .to eq 1
          end

          # A few properties (e.g. 7022 have 0, -1 as empty due date)
          it 'stops on empty due date (0,-1)' do
            charge_row = %q(9,, GR, 0, 5.5, S, 1, 1, 0, -1, 0, 0, 0, 0,, 0)
            expect(ChargeRow.new(parse_line(charge_row)).day_months.count)
              .to eq 1
          end
        end

        it 'maximum day month pairs of 4' do
          quarter_charge = %q(9,, GR, 0, 5, S, 1, 1, 2, 2, 3, 3, 4, 4,, 0)
          expect(ChargeRow.new(parse_line quarter_charge).day_months.count)
            .to eq 4
        end

        it 'always receive two values for half year charges' do
          h_charge_with_4_charge_dates = \
            %q(9,, H, 0, 5.5, S, 1, 1, 2, 2, 3, 3, 4, 4,, 0)
          row = ChargeRow.new parse_line h_charge_with_4_charge_dates
          expect(row.day_months.count).to eq 2
        end

        it 'creates monthly day and months' do
          monthly = %q(9,, M, 0, 5.5, S, 24, 0, 0, 0, 0, 0, 0, 0,, 0)
          row = ChargeRow.new parse_line monthly
          expect(row.day_months.count).to eq 12
          expect(row.day_months[0..1]).to eq [DueOnImportable.new(1, 24),
                                              DueOnImportable.new(2, 24)]
        end
      end

      it 'returns expected attributes' do
        row = ChargeRow.new parse_line charge_row
        expect(row.attributes[:charge_type]).to eq 'Ground Rent'
        expect(row.attributes[:amount]).to eq 50.5
        expect(row.attributes[:payment_type]).to eq 'automatic'
      end
    end

    describe 'activity' do
      it 'is active is there is an amount' do
        charge = charge_row amount: 20
        expect(ChargeRow.new(parse_line charge).activity).to eq 'active'
      end

      it 'is active is there is an amount' do
        charge = charge_row amount: 0
        expect(ChargeRow.new(parse_line charge).activity).to eq 'dormant'
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.charge,
                     header_converters: :symbol,
                     converters: ->(field) { field ? field.strip : nil })
    end
  end
end
