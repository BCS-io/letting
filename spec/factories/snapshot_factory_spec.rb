require 'rails_helper'

describe 'Snapshot Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(invoice_new).to be_valid }

      context 'makes' do
        it 'makes debits' do
          expect { snapshot_new.save! }.to change(Debit, :count).by(1)
        end
      end
    end
  end
  describe 'create' do
    it 'makes snapshots' do
      expect { snapshot_create }.to change(Snapshot, :count).by(1)
    end
  end
end
