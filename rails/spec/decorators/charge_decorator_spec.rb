require 'rails_helper'

RSpec.describe ChargeDecorator do
  it '#charged_in - returns capitalized string' do
    charge = ChargeDecorator
             .new charge_new cycle: cycle_new(charged_in: 'advance')
    expect(charge.charged_in).to eq 'Advance'
  end

  it '#payment returns capitalized string' do
    charge = ChargeDecorator.new charge_new payment_type: 'automatic'
    expect(charge.payment).to eq 'Automatic'
  end

  it '#activity - returns capitalized string' do
    charge = ChargeDecorator.new charge_new activity: 'active'
    expect(charge.activity).to eq 'Active'
  end

  describe '#emphasis' do
    it 'can be emphasized' do
      charge = ChargeDecorator.new charge_new activity: 'active'
      expect(charge.emphasis).to eq ''
    end

    it 'can be deemphasized' do
      charge = ChargeDecorator.new charge_new activity: 'dormant'
      expect(charge.emphasis).to eq 'deemphasized'
    end
  end
end
