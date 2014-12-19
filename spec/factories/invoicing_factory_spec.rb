require 'rails_helper'

describe 'Invoicing Factory' do
  describe 'default' do
    it('is valid') { expect(invoicing_new).to be_valid }
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
    it 'is on the second run' do
      expect(invoicing_new).not_to be_first_run
    end
  end

  describe 'override' do
    it 'can be set to first run' do
      expect(invoicing_new runs: []).to be_first_run
    end
  end
end
