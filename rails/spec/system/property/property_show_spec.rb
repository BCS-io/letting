require 'rails_helper'

#
# Property's route path is to account
#
RSpec.describe 'Property#show', type: :system do
  before { log_in }

  it 'has basic details' do
    property_create id: 1,
                    human_ref: 1000,
                    agent: agent_new(entities: [Entity.new(name: 'Bell')],
                                     address: address_new(road: 'Wiggiton')),
                    account: account_new
    visit '/accounts/1'
    expect(page.title).to eq 'Letting - View Account'
    expect_property entity: 'Mr W. G. Grace'
    expect_agent_info entity: 'Bell', road: 'Wiggiton'
  end

  def expect_property(entity:)
    expect(page).to have_text entity
    expect(page).to have_text '1000'
    expect(page).to have_text 'Edgbaston'
  end

  def expect_agent_info(entity:, road:)
    expect(page).to have_text entity
    [road].each do |line|
      expect(page).to have_text line
    end
  end

  it 'shows when charged' do
    charge = charge_create(charge_type: 'Rent')
    property_create id: 1,
                    account: account_new(charges: [charge])
    visit '/accounts/1'
    expect(page).to have_text 'Rent'
  end

  it 'shows charges as dormant' do
    property_create \
      id: 1,
      account: account_new(charges: [charge_new(activity: 'dormant')])
    visit '/accounts/1'
    within 'div#charge' do
      expect(page).to have_text 'Dormant'
    end
  end

  describe 'no charges message' do
    it 'displays message when account has no charges' do
      property_create id: 1, account: account_new(charges: [])
      visit '/accounts/1'

      expect(page.text).to match /No charges levied against this property./i
    end

    it 'hides message when client has properties' do
      property_create id: 1, account: account_new(charges: [charge_new])
      visit '/accounts/1'

      expect(page.text).not_to match /No charges levied against this property./i
    end
  end
end
