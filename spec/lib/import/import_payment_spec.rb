require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/import_payment'

module DB
  describe ImportPayment, :import do
    it 'single credit' do
      property_create human_ref: 89,
                      account: account_new(charges: [charge_create])

      expect { ImportPayment.import parse credit_row }
        .to change(Credit, :count).by 1
    end

    describe 'errors' do
      it 'double import raises error' do
        property_create human_ref: 89,
                        account: account_new(charges: [charge_new])
        expect { warn 'DB::ImportPayment is not idempotent.' }
          .to output.to_stderr
        ImportPayment.import parse credit_row human_ref: 89
        ImportPayment.import parse credit_row(human_ref: 89)
      end
    end

    def credit_row human_ref: 89, amount: 50.5
      %(#{human_ref}, GR, 2012-03-25 12:00:00, Ground Rent, 0, #{amount} , 0)
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.account,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil })
    end
  end
end
