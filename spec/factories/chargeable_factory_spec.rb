require 'rails_helper'

RSpec.describe 'ChargeableFactory' do
  describe 'default' do
    it('has account_id') { expect(chargeable_new.account_id).to eq 2 }
    it('has charge_id') { expect(chargeable_new.charge_id).to eq 1 }
    it 'has at_time' do
      expect(chargeable_new.at_time).to eq Date.new(2013, 3, 25)
    end
    it 'has period' do
      expect(chargeable_new.period.to_s).to eq '2013-03-25..2013-06-30'
    end
    it('has amount') { expect(chargeable_new.amount).to eq 88.08 }
  end
end
