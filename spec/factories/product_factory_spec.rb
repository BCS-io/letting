require 'rails_helper'

RSpec.describe 'Product Factory' do
  describe 'default' do
    it('is valid') { expect(product_new).to be_valid }
    it('has charge') { expect(product_new.charge_type).to eq 'Rent' }
    it 'has date_due' do
      expect(product_new.date_due.to_s).to eq '2014-06-07'
    end
    it 'has range' do
      expect(product_new.period)
        .to eq Date.new(2010, 9, 30)..Date.new(2011, 3, 25)
    end
  end

  describe 'override' do
    it 'overrides charge_type' do
      expect(product_new(charge_type: 'gas').charge_type).to eq 'gas'
    end
  end
end
