require 'rails_helper'

RSpec.describe SnapshotMaker, type: :model do
  describe '#invoice' do
    it 'returns the snapshot' do
      cycle = cycle_create(due_ons: [DueOn.new(month: 3, day: 5)])
      account = account_new charges: [charge_new(cycle: cycle)]
      make = SnapshotMaker.new account: account,
                               debit_period: '2013/03/05'..'2013/05/05'

      expect(make.invoice.debits.size).to eq(1)
    end
  end
end
