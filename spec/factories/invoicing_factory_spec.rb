require 'rails_helper'

describe 'Invoicing Factory' do
  describe 'default' do
    it "is valid if covers an account's human_ref" do
      property_create human_ref: 1, account: account_new
      expect(invoicing_new).to be_valid
    end
    describe 'presence' do
      it 'property_range' do
        expect(invoicing_new property_range: nil).to_not be_valid
      end
      it 'period_first' do
        expect(invoicing_new period_first: nil).to_not be_valid
      end
      it 'period_last' do
        expect(invoicing_new period_last: nil).to_not be_valid
      end
      it('runs') { expect(invoicing_new runs: nil).to_not be_valid }
    end
  end
end
