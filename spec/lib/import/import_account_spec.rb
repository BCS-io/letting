require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/import_account'

module DB
  describe ImportAccount, :import do
    describe 'import_row' do
      def debit
        %q(8, GR, 2011-12-25 00:00:00, Ground Rent..., 47.5,    0, 47.5)
      end

      it 'imports debits' do
        create_charged_property human_ref: 8,
                                cycle: new_cycle(month: 12, day: 25)
        expect { import_account debit }.to change(Debit, :count).by 1
      end

      def payment
        %q(8, GR, 2012-01-11 15:32:00, Payment Gr....,    0, 47.5,    0)
      end

      it 'imports payment' do
        create_charged_property human_ref: 8,
                                cycle: new_cycle(month: 12, day: 25)
        expect { ImportAccount.import parse payment }
          .to change(Payment, :count).by 1
      end

      def balance
        %q(8, GR, 2004-12-25 00:00:00, Balance,   17.5  0 17.5)
      end

      it 'imports balance' do
        create_charged_property human_ref: 8,
                                cycle: new_cycle(month: 12, day: 25)
        expect { ImportAccount.import parse balance }
          .to change(Debit, :count).by 1
      end
    end

    describe 'filter' do
      def single_row
        %q(8, GR, 2011-12-25 00:00:00, Ground Rent..., 47.5,    0, 47.5)
      end

      it 'allows within range' do
        create_charged_property human_ref: 8,
                                cycle: new_cycle(month: 12, day: 25)
        expect { import_account single_row, range: 8..8 }
          .to change(Debit, :count).by 1
      end

      it 'filters if out of range' do
        create_charged_property human_ref: 8,
                                cycle: new_cycle(month: 12, day: 25)
        expect { import_account single_row, range: 2..7 }
          .to change(Debit, :count).by 0
      end
    end

    def create_charged_property human_ref: 8, cycle: new_cycle
      property_create human_ref: human_ref,
                      account: account_new(charges: [charge_new(cycle: cycle)])
    end

    def new_cycle(month: 12, day: 25)
      cycle_new due_ons: [DueOn.new(month: month, day: day)]
    end

    def import_account row, **args
      ImportAccount.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
