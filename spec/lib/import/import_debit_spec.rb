require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/import_debit'

####
#
# import_debit_spec.rb
#
# unit testing for ImportDebit
#
####
#
module DB
  describe ImportDebit, :import do
    let!(:property) do
      cycle = cycle_new(due_ons: [DueOn.new(month: 6, day: 6)])
      property_create \
        human_ref: 122,
        account: account_new(charges: [charge_new(cycle: cycle)])
    end

    context 'one debit' do
      def one_debit_csv
        %q(122, GR, 2011-6-6 12:00:00, Ground Rent..., 37.5,    0, 37.5)
      end

      it 'parsed' do
        expect { ImportDebit.import parse one_debit_csv }
          .to change(Debit, :count).by 1
      end
    end

    context 'two debits' do
      def two_debit_csv
        %q(122, GR, 2011-6-6 12:00:00, Ground Rent..., 37.5,    0, 37.5
           122, GR, 2012-6-6 12:00:00, Ground Rent..., 37.5,    0, 37.5)
      end

      it 'parsed' do
        expect { ImportDebit.import parse two_debit_csv }
          .to change(Debit, :count).by 2
      end
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: ->(field) { field ? field.strip : nil })
    end
  end
end
