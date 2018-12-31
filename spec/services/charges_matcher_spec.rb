require 'rails_helper'

module DB
  RSpec.describe ChargesMatcher do
    describe '#first_or_initialize' do
      it 'builds a charge if the charge type is unknown' do
        account = account_new charges: [charge_new(charge_type: 'Rent')]
        (matcher = ChargesMatcher.new(account.charges))
          .first_or_initialize 'Unknown'
        expect(matcher.size).to eq(2)
      end

      it 'returns the first matching charge' do
        account = account_new charges: [charge_new(charge_type: 'Rent')]
        (matcher = ChargesMatcher.new(account.charges))
          .first_or_initialize 'Rent'
        expect(matcher.size).to eq(1)
      end
    end
  end
end
