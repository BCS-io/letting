require 'csv'
require 'rails_helper'
require_relative '../../../../lib/import/file_header'
require_relative '../../../../lib/import/charges/import_charge'

####
#
# import_charge_spec.rb
#
# unit testing for charge_row
#
####
#
module DB
  include ChargedInDefaults
  RSpec.describe ImportCharge, :import do
    def row human_ref: 80, charged_in: LEGACY_ARREARS, month: 3, day: 5, amount: 5
      %(#{human_ref}, 2006-12-30 17:17:00, GR, #{charged_in}, #{amount},  S,) +
        %(#{day}, #{month}, 0, 0,  0,  0,  0,  0, 1900-01-01 00:00:00, 0 )
    end

    describe 'import characteristics' do
      before do
        property_create human_ref: 80, account: account_new
        cycle_create charged_in: MODERN_ARREARS,
                     due_ons: [DueOn.new(month: 3, day: 5)]
      end

      describe 'activity' do
        it 'is active is there is an amount' do
          import_charge row amount: 20

          expect(Charge.first).to be_active
        end

        it 'is active is there is an amount' do
          import_charge row amount: 0

          expect(Charge.first).to be_dormant
        end
      end

      it 'does not double import' do
        import_charge row human_ref: 80
        expect { import_charge row human_ref: 80 }.to_not change(Charge, :count)
      end

      it 'can update charge' do
        import_charge row(amount: 25.00)
        import_charge row(amount: 30.05)
        expect(Charge.first.amount).to eq 30.05
      end

      it 'errors if property does not exist' do
        expect { warn 'Property human_ref: 82 - Not found' }.to output.to_stderr
        import_charge row human_ref: 82
      end

      describe 'property filter' do
        it 'allows within given range' do
          expect { import_charge row(human_ref: 80), range: 80..80 }
            .to change(Charge, :count).by 1
        end

        it 'filters when outside range' do
          expect { import_charge row(human_ref: 80), range: 10..79 }
            .to change(Charge, :count).by 0
        end
      end
    end

    context 'on_date cycle' do
      it 'imports a single row' do
        property_create human_ref: 80, account: account_new
        cycle_create charged_in: MODERN_ARREARS,
                     due_ons: [DueOn.new(month: 3, day: 5)]
        expect { import_charge row }.to change(Charge, :count).by 1
      end
    end

    context 'monthly cycle' do
      it 'imports a single row' do
        property_create human_ref: 80, account: account_new
        cycle_create charged_in: MODERN_ARREARS,
                     due_ons: [DueOn.new(month: 0, day: 7)]

        expect do
          import_charge row human_ref: 80,
                            charged_in: LEGACY_ARREARS,
                            month: 0,
                            day: 7
        end.to change(Charge, :count).by 1
      end
    end

    def import_charge row, **args
      ImportCharge.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.charge,
                header_converters: :symbol,
                converters: ->(field) { field ? field.strip : nil })
    end
  end
end
