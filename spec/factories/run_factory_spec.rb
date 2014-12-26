require 'rails_helper'

describe 'Run Factory' do
  describe 'default' do
    it('is valid') { expect(run_new).to be_valid }
    describe 'presence' do
      it('invoices') { expect(run_new invoices: nil).to_not be_valid }
    end
  end

  describe 'override' do
    it 'does not have invoices' do
      expect(run_new(invoices: []).invoices).to be_empty
    end
  end
end
