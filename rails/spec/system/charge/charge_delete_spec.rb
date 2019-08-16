require 'rails_helper'
#
# Deleting a charge can only happen with current property
# Tests create and use a property in all instances.
#
RSpec.describe 'Charge#delete', type: :system do
  let(:account) { AccountPage.new }

  before do
    log_in
    property_create id: 1,
                    human_ref: 80,
                    account: account_new,
                    client: client_new(human_ref: 90)
  end

  it 'deletes charge', js: true, elasticsearch: true do
    charge = charge_create cycle: cycle_new(id: 1, charged_in: 'advance')
    Account.first.charges << charge
    account.load id: 1
    expect(Account.first.charges.size).to eq 1

    account.delete_charge

    account.button('Update').successful?(self)

    expect(Account.first.charges.size).to eq 0
  end
end
