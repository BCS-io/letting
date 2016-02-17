require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/import_balance'

####
#
# import_debit_spec.rb
#
# unit testing for ImportDebit
#
####
#
module DB
  describe ImportBalance, :import do
    describe 'unnamed debit only one charge' do
      def row_code charge_code: 'GR', description: 'Balance'
        %(8, #{charge_code}, 2004-03-24 00:00:00, #{description}, 37.5,    0, 37.5)
      end

      describe 'balance from description' do
        it 'balance with one charge as arrears for that charge' do
          cycle = cycle_new(due_ons: [DueOn.new(month: 3, day: 25)])
          property_create \
            human_ref: 8,
            account: account_new(charges: [charge_new(cycle: cycle)])

          expect { ImportBalance.import parse row_code }
            .to change(Debit, :count).by 1
        end
      end

      def row_desc charge_code: 'Bal', description: 'Balance Service Charge'
        %(8, #{charge_code}, 2013-02-01 00:00:00, #{description}, 37.5,    0, 37.5)
      end

      describe 'balance with subject' do
        it 'matches a charge code using the description' do
          charge = charge_new charge_type: ChargeTypes::SERVICE_CHARGE,
                              cycle: cycle_new
          property_create human_ref: 8, account: account_new(charges: [charge])
          expect { ImportBalance.import parse row_desc }
            .to change(Debit, :count).by 1
        end
      end
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
