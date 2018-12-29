require 'rails_helper'

describe Chargeable, :ledgers, type: :model do
  let(:chargeable) do
    Chargeable.from_charge charge_id: 1,
                           account_id: 2,
                           at_time: Date.new(2013, 3, 25),
                           period: '2013-3-25'..'2013-6-30',
                           amount: 88.08
  end

  describe 'attributes' do
    it('account_id') { expect(chargeable.account_id).to eq 2 }
    it('charge_id') { expect(chargeable.charge_id).to eq 1 }
    it('date') { expect(chargeable.at_time).to eq Date.new(2013, 3, 25) }
    it 'period' do
      expect(chargeable.period)
        .to eq '2013-3-25'..'2013-6-30'
    end
    it('amount') { expect(chargeable.amount).to eq 88.08 }
  end

  describe 'methods' do
    it 'self.from_charge generates chargeable' do
      chargeable = Chargeable.from_charge \
        account_id: 2,
        charge_id: 1,
        at_time: Date.new(2013, 3, 25),
        period: '2013-3-25'..'2013-6-30',
        amount: 88.08
      expect(chargeable.class).to be Chargeable
    end

    describe '#to_hash' do
      it 'outputs a hash' do
        expect(chargeable.to_hash)
          .to eq account_id: 2,
                 charge_id: 1,
                 at_time: Date.new(2013, 3, 25),
                 period: '2013-3-25'..'2013-6-30',
                 amount: 88.08
      end

      it 'overrides an attribute' do
        chargeable_hash = chargeable.to_hash amount: 90.08
        expect(chargeable_hash[:amount]).to eq 90.08
      end
    end
  end
end
