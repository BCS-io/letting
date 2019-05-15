require 'rails_helper'

RSpec.describe 'Charges', :ledgers, type: :model do
  let(:charges) { account_new.charges }

  it '#prepare_for_form' do
    expect(charges.size).to eq(0)
    charges.prepare
    expect(charges.size).to eq(Account::MAX_CHARGES)
  end

  it '#cleans up form' do
    charges << charge_new
    charges.prepare
    charges.clear_up_form
    expect(charges.reject(&:marked_for_destruction?).size).to eq(1)
  end
end
