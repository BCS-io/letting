require 'rails_helper'

RSpec.describe 'Account Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(account_new).to be_valid }
      it('has no charge') { expect(Charge.count).to eq 0 }
    end

    describe 'adds' do
      it 'can add property' do
        expect(account_new(property: property_new(human_ref: 5)).property.human_ref).to eq 5
      end
      it 'can add charge' do
        expect(account_new(charges: [charge_new]).charges[0].charge_type)
          .to eq 'Ground Rent'
      end
      it 'can add cycle' do
        expect(account_new(charges: [charge_new]).charges[0].cycle.name)
          .to eq 'Mar'
      end
      it 'can add due_on' do
        expect(account_new(charges: [charge_new])
          .charges[0].cycle.due_ons[0])
          .to eq DueOn.new(month: 3, day: 25)
      end
      it 'can add debit' do
        expect(account_new(debits: [debit_new(amount: 17)]).debits[0].amount)
          .to eq 17
      end
      it 'can add credit' do
        expect(account_new(credits: [credit_new(amount: 17)]).credits[0].amount)
          .to eq 17
      end
      it 'can add payment' do
        expect(account_new(payment: payment_new(amount: 17)).payments[0].amount)
          .to eq 17
      end
    end
  end

  describe 'create' do
    it 'is creates' do
      expect { account_create }.to change(Account, :count).by 1
    end
    it 'can change property reference' do
      expect(account_create(property: property_new(human_ref: 5)).property.human_ref).to eq 5
    end
    it 'can change property address' do
      account_create(property: property_new(address: address_new(road: 'Hill')))

      expect(Account.first.property.address.road).to eq 'Hill'
    end
  end
end
