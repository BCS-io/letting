require 'rails_helper'

RSpec.describe 'Credit Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(credit_new).to be_valid }
      it 'is requires charge to be valid' do
        expect(credit_new charge: charge_new).to be_valid
      end
      it('has amount') { expect(credit_new.amount).to eq(88.08) }
      it 'has date' do
        expect(credit_new.at_time).to eq Time.zone.local(2013, 4, 30, 0, 0, 0)
      end
    end

    describe 'overrides' do
      it 'alters amount' do
        expect(credit_new(amount: 35.50).amount).to eq(35.50)
      end
      it 'alters date' do
        expect(credit_new(at_time: '10/6/2014').at_time)
          .to eq Time.zone.local(2014, 6, 10, 0, 0, 0)
      end
    end
  end

  describe 'create' do
    let(:charge) { charge_create }

    describe 'default' do
      it 'is created' do
        expect { credit_create charge: charge }.to change(Credit, :count).by(1)
      end
      it 'has amount' do
        expect(credit_create(charge: charge).amount).to eq(88.08)
      end
      it 'has date' do
        expect(credit_create(charge: charge).at_time)
          .to eq Time.zone.local(2013, 4, 30, 0, 0, 0)
      end
    end

    describe 'override' do
      it 'alters amount' do
        expect(credit_create(charge: charge, amount: 35.50).amount).to eq(35.50)
      end
      it 'alters date' do
        expect(credit_create(charge: charge, at_time: '10/6/2014').at_time)
          .to eq Time.zone.local(2014, 6, 10, 0, 0, 0)
      end
    end
  end
end
