require 'rails_helper'
# rubocop: disable Style/SpaceInsideRangeLiteral

describe ProductDecorator, :invoice do
  describe 'methods' do
    it 'returns #date_due formatted' do
      product_dec = ProductDecorator.new product_new date_due: '2014-06-07'
      expect(product_dec.date_due).to eq '07/Jun/14'
    end

    it 'returns #period formatted' do
      product_dec =
        ProductDecorator.new product_new period: Date.new(2010, 9, 30)..
                                                 Date.new(2011, 3, 25)
      expect(product_dec.period).to eq '30/Sep/10 - 25/Mar/11'
    end

    it 'returns empty string if #period range nil' do
      product_dec = ProductDecorator.new product_new period: nil..nil
      expect(product_dec.period).to eq '&nbsp;'
    end
  end
end