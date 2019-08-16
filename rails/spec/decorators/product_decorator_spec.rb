require 'rails_helper'

RSpec.describe ProductDecorator, :invoice do
  describe 'methods' do
    describe '#date_due' do
      it 'returns #date_due formatted' do
        product_dec = described_class.new product_new date_due: '2014-06-07'
        expect(product_dec.date_due).to eq '07/Jun/14'
      end

      it 'blanks out arrears' do
        product_dec = described_class.new product_new charge_type: ChargeTypes::ARREARS,
                                                      date_due: '2014-06-07'
        expect(product_dec.date_due).to eq '&nbsp;'
      end
    end

    it 'returns #period formatted' do
      product_dec = described_class.new product_new period: '2010-9-30'..'2011-3-25'
      expect(product_dec.period).to eq '30/Sep/10 - 25/Mar/11'
    end

    it 'returns empty string if #period range nil' do
      product_dec = described_class.new product_new period: nil..nil
      expect(product_dec.period).to eq '&nbsp;'
    end

    it 'returns the amount_on_time' do
      product = product_new amount: 20.05, date_due: Date.new(2010, 9, 30)
      expect(described_class.new(product).amount_on_time) .to eq '£20.05 on 30/Sep/10'
    end
  end
end
