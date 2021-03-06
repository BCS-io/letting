require 'rails_helper'

RSpec.describe 'Snapshot Factory' do
  describe 'snapshot_new' do
    describe 'default' do
      it('is valid') { expect(snapshot_new).to be_valid }

      it 'makes account' do
        expect { snapshot_new.save! }.to change(Account, :count).by(1)
      end

      it 'makes debits' do
        expect { snapshot_new.save! }.to change(Debit, :count).by(1)
      end
    end

    describe 'overrides' do
      it 'alters account' do
        account = account_new
        snapshot = snapshot_new(account: account)

        expect(snapshot.account).to eq account
      end
    end
  end

  describe 'snapshot_create' do
    it 'makes snapshots' do
      expect { snapshot_create }.to change(Snapshot, :count).by(1)
    end

    it 'can change account' do
      account = account_create
      snapshot_create(account: account)

      expect(Snapshot.first.account).to eq account
    end
  end
end
