require 'rails_helper'

RSpec.describe 'Debit Factory' do
  describe 'debit_new' do
    describe 'default' do
      it('is not valid') { expect(debit_new).not_to be_valid }
      it 'is requires charge to be valid' do
        expect(debit_new charge: charge_new).to be_valid
      end
      it 'has date' do
        expect(debit_new.at_time)
          .to eq Time.zone.local(2013, 3, 25, 10, 0, 0)
      end
      it 'has period' do
        expect(debit_new.period)
          .to eq Date.new(2013, 3, 25)..Date.new(2013, 6, 30)
      end
      it('has amount') { expect(debit_new.amount).to eq(88.08) }
    end

    describe 'overrides' do
      it 'alters amount' do
        expect(debit_new(amount: 35.50).amount).to eq(35.50)
      end
      it('nils date') { expect(debit_new at_time: nil).not_to be_valid }
      it 'alters date' do
        expect(debit_new(at_time: '10/6/2014').at_time)
          .to eq Time.zone.local(2014, 6, 10, 0, 0, 0)
      end
      it 'alters period' do
        period = Date.new(2014, 3, 25)..Date.new(2014, 6, 30)
        expect(debit_new(period: period).period.to_s)
          .to eq '2014-03-25..2014-06-30'
      end
    end

    describe 'adds' do
      it 'assigns charge' do
        charge = charge_new charge_type: 'Rent'
        expect(debit_new(charge: charge).charge_type).to eq 'Rent'
      end
    end
  end

  describe 'create' do
    let(:charge) { charge_create }

    describe 'default' do
      it 'is created if charge_id set' do
        expect { debit_create charge: charge }.to change(Debit, :count).by(1)
      end
      it 'has amount' do
        expect(debit_create(charge: charge).amount).to eq(88.08)
      end
      it 'has date' do
        expect(debit_create(charge: charge).at_time)
          .to eq Time.zone.local(2013, 3, 25, 10, 0, 0)
      end
    end

    describe 'override' do
      it 'alters amount' do
        expect(debit_create(charge: charge, amount: 35.50).amount).to eq(35.50)
      end
      it 'alters date' do
        expect(debit_create(charge: charge, at_time: '10/6/2014').at_time)
          .to eq Time.zone.local(2014, 6, 10, 0, 0, 0)
      end
    end
  end
end
