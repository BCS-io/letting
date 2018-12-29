require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/accounts/credit_row'

module DB
  describe CreditRow, :import do
    def row human_ref: 9,
            charge_code: 'GR',
            date: '2012-03-25 12:00:00',
            amount: 5.5
      CreditRow.new parse_line \
        %(#{human_ref}, #{charge_code}, #{date}, Ground Rent, 0, #{amount}, 0)
    end

    it('human_ref') { expect(row(human_ref: 9).human_ref).to eq 9 }
    it('charge_code') { expect(row(charge_code: 'GR').charge_code).to eq 'GR' }
    it('at_time') { expect(row.at_time).to eq '2012-03-25 12:00:00' }
    it('amount') { expect(row(amount: '5.5').amount).to eq(5.5) }

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.account,
                     header_converters: :symbol,
                     converters: ->(field) { field ? field.strip : nil })
    end
  end
end
