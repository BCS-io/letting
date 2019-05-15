require 'rails_helper'

RSpec.describe AccountDebitDecorator do
  let(:debit_dec) { AccountDebitDecorator.new debit_new }

  context 'attributes has' do
    it 'charge_type' do
      debit_dec.charge = charge_new charge_type: 'Rent'
      expect(debit_dec.charge_type).to eq 'Rent'
    end

    it 'date' do
      expect(debit_dec.at_time).to eq Time.zone.local 2013, 3, 25, 10, 0, 0
    end

    it 'due' do
      expect(debit_dec.due).to eq '88.08'
    end

    describe 'description' do
      it 'returns a date range string' do
        expect(debit_dec.description).to eq '25/Mar/13 to 30/Jun/13'
      end

      it 'returns arrears description when start date is a minimum date' do
        dec = AccountDebitDecorator.new \
          debit_new period: Time.zone.local(2000, 1, 1)..Date.new(2013, 6, 30)
        expect(dec.description).to eq 'Arrears'
      end
    end

    it 'payment' do
      expect(debit_dec.payment).to eq ''
    end

    it 'amount' do
      expect(debit_dec.amount).to eq 88.08
    end
  end
end
