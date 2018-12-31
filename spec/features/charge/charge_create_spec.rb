require 'rails_helper'
#
# Creating a charge can only happen with current property
# Tests create and use a property in all instances.
#
describe 'Charge#create', type: :feature do
  let(:account) { AccountPage.new }
  before(:each) do
    log_in
    property_create id: 1,
                    human_ref: 80,
                    account: account_new,
                    client: client_new(human_ref: 90)
  end

  it 'main success - adds a charge' do
    cycle = cycle_create(id: 1, charged_in: 'advance')
    account.load id: 1
    expect(Charge.first).to be_nil

    account.charge charge: charge_new(cycle: cycle,
                                      charge_type: 'Rent',
                                      payment_type: 'manual',
                                      amount: 12.05)
    account.button('Update').successful?(self)

    expect(Charge.count).to eq 1
    expect(Charge.first.charge_type).to eq 'Rent'
    expect(Charge.first.cycle_id).to eq 1
    expect(Charge.first.amount).to eq 12.05
  end

  describe 'empty charge row' do
    it 'displays an empty charge row if no charges present', js: true do
      account.load

      within 'div#t-charge' do
        expect(page).to have_css('.spec-charge-count', count: 1)
      end
    end

    it 'can display adds charges', js: true do
      account.load

      within 'div#t-charge' do
        expect(page).to have_css('.spec-charge-count', count: 1)
      end
      click_on 'Add Charge'

      within 'div#t-charge' do
        expect(page).to have_css('.spec-charge-count', count: 2)
      end
    end
  end

  it 'can fills in a charge but delete it before updating', js: true do
    cycle = cycle_create id: 1, charged_in: 'advance'
    account.load id: 1

    expect(Charge.count).to eq 0

    account.charge order: 0, charge: charge_new(cycle: cycle,
                                                charge_type: 'Rent',
                                                payment_type: 'manual',
                                                amount: 12.05)
    account.delete_charge
    account.button('Update').successful?(self)

    expect(Charge.count).to eq 0
  end

  describe 'can fill two charges at once (2.a.)' do
    it 'main case succeeds', js: true do
      cycle = cycle_create(id: 1, charged_in: 'advance')
      account.load id: 1
      expect(Charge.first).to be_nil

      account.charge order: 0, charge: charge_new(cycle: cycle,
                                                  charge_type: 'Rent',
                                                  payment_type: 'manual',
                                                  amount: 12.05)

      click_on 'Add Charge'

      account.charge order: 1, charge: charge_new(cycle: cycle,
                                                  charge_type: 'Service',
                                                  payment_type: 'manual',
                                                  amount: 20.01)

      account.button('Update').successful?(self)

      expect(Charge.second.charge_type).to eq 'Service'
      expect(Charge.second.cycle_id).to eq 1
      expect(Charge.second.amount).to eq 20.01
    end

    it 'can still delete the first before updating', js: true do
      cycle = cycle_create id: 1, charged_in: 'advance'
      account.load id: 1

      expect(Charge.count).to eq 0

      account.charge order: 0, charge: charge_new(cycle: cycle,
                                                  charge_type: 'Rent',
                                                  payment_type: 'manual',
                                                  amount: 12.05)

      click_on 'Add Charge'

      account.charge order: 1, charge: charge_new(cycle: cycle,
                                                  charge_type: 'Service',
                                                  payment_type: 'manual',
                                                  amount: 20.01)

      # note zero ordered
      page.all('.t-charge-count')[0].click
      account.button('Update').successful?(self)

      expect(Charge.count).to eq 1
    end

    it 'can still delete the second before updating', js: true do
      cycle = cycle_create id: 1, charged_in: 'advance'
      account.load id: 1

      expect(Charge.count).to eq 0

      account.charge order: 0, charge: charge_new(cycle: cycle,
                                                  charge_type: 'Rent',
                                                  payment_type: 'manual',
                                                  amount: 12.05)

      click_on 'Add Charge'

      account.charge order: 1, charge: charge_new(cycle: cycle,
                                                  charge_type: 'Service',
                                                  payment_type: 'manual',
                                                  amount: 20.01)

      # note zero ordered
      page.all('.t-charge-count')[1].click
      account.button('Update').successful?(self)

      expect(Charge.count).to eq 1
    end
  end
end
