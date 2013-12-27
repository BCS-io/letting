require 'spec_helper'

describe Charge do
  let(:charge) do
    charge = Charge.new charge_attributes id: 1
    charge.due_ons.new due_on_attributes_0 charge_id: 1
    charge
  end

  it('is valid') { expect(charge).to be_valid }

  context 'validations' do
    context 'presence' do

      it 'charge type' do
        charge.charge_type = nil
        expect(charge).to_not be_valid
      end

      it 'due in' do
        charge.due_in = nil
        expect(charge).to_not be_valid
      end

      it 'amount' do
        charge.amount = nil
        expect(charge).to_not be_valid
      end

      it 'due_ons' do
        charge.due_ons.destroy_all
        expect(charge).to_not be_valid
      end
    end
    context 'amount' do
      it 'is a number' do
        charge.amount = 'nnn'
        expect(charge).to_not be_valid
      end
      it 'has a maximum' do
        charge.amount = 100_000
        expect(charge).to_not be_valid
      end
    end
  end

  context 'methods' do

    context 'charging' do
      before { Timecop.travel(Date.new(2013, 1, 31)) }
      after  { Timecop.return }

      context '#next' do
        it 'if charge between dates'  do
          charge.due_ons.new due_on_attributes_1 charge_id: 1
          charge.debits.build debit_attributes on_date: '2013-3-25'
          expect(charge.next(Date.new(2013, 3, 25) .. Date.new(2014, 3, 25)))
            .to eq ChargeableInfo.from_charge chargeable_attributes on_date: Date.new(2013,9,30)
        end

        it 'return nil if not' do
          expect(charge.next(dates_not_charged_on))
            .to be_nil
        end
      end

      def date_when_charged
        Date.new(2013, 3, 25) .. Date.new(2013, 3, 25)
      end

      def dates_not_charged_on
        Date.new(2013, 2, 1) .. Date.new(2013, 3, 24)
      end
    end

    it '#prepare creates children' do
      charge.prepare
      expect(charge.due_ons).to have(4).items
    end

    it '#clear_up_form destroys children' do
      charge.clear_up_form
      expect(charge.due_ons).to have(1).items
    end
  end
end
