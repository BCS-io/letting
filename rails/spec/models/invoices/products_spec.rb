require 'rails_helper'

#
# specs for testing the products collection
#
#
RSpec.describe 'Products', type: :model do
  describe '#drop_arrears' do
    it 'removes arrears from products' do
      invoice =
        Invoice.new products: [product_new(charge_type: ChargeTypes::ARREARS),
                               product_new(charge_type: ChargeTypes::INSURANCE)]
      products = invoice.products.drop_arrears

      expect(products.first.charge_type).to_not eq 'Arrears'
      expect(products.first.charge_type).to eq 'Insurance'
    end

    it 'leaves anything not to do with arrears' do
      invoice =
        Invoice.new products: [product_new(charge_type: ChargeTypes::INSURANCE)]
      products = invoice.products.drop_arrears

      expect(products.first.charge_type).to eq 'Insurance'
    end
  end

  describe '#total_arrears' do
    it 'returns zero when no products' do
      invoice = Invoice.new products: []

      expect(invoice.total_arrears).to eq 0
    end

    it 'returns sum of product arrears' do
      invoice = Invoice.new products: [product_new(balance: 30.05)]

      expect(invoice.total_arrears).to eq 30.05
    end
  end
end
