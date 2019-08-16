require 'rails_helper'

RSpec.describe 'Invoicing Factory' do
  describe 'invoicing_new' do
    describe 'default' do
      it "is valid if covers an account's human_ref" do
        property_create human_ref: 1, account: account_new
        expect(invoicing_new).to be_valid
      end

      it 'property_range' do
        expect(invoicing_new property_range: nil).not_to be_valid
      end
      it('runs') { expect(invoicing_new runs: nil).not_to be_valid }
    end
  end

  describe 'invoicing_create' do
    it 'is valid' do
      property_create human_ref: 1, account: account_new
      expect(invoicing_create).to be_valid
    end
  end
end
