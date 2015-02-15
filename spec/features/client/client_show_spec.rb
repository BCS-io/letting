require 'rails_helper'

describe 'Client#show', type: :feature do
  before { log_in }

  it 'has basic details' do
    client_create(id: 1, human_ref: 87)
      .properties << property_new(human_ref: 2008)
    visit '/clients/1'

    expect(page.title).to eq 'Letting - View Client'
    expect_client_ref ref: 87
    expect_property_ref ref: 2008
  end

  it '#show payments' do
    charge =
      charge_create cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 25),
                                               DueOn.new(month: 9, day: 30)])
    payment = payment_new booked_at: '2014-3-1', amount: 17.35
    client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
      .properties << property_new(human_ref: 63,
                                  account: account_new(charges: [charge],
                                                       payment: payment))

    visit '/clients/1'

    expect(page).to have_text '17.35'
  end

  it '#show aggregated payments' do
    charge =
      charge_create cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 25),
                                               DueOn.new(month: 9, day: 30)])
    payment = payment_new booked_at: '2014-5-1', amount: 17.35
    client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
      .properties << property_new(human_ref: 63,
                                  account: account_new(charges: [charge],
                                                       payment: payment))
    visit '/clients/1'

    expect(page).to have_text '17.35'
    click_on '17.35'
    expect(page).to have_text 'Print Mar 2014'
  end

  it '#show detailed payments for an aggregation' do
    charge =
      charge_create cycle: cycle_new(due_ons: [DueOn.new(month: 3, day: 25),
                                               DueOn.new(month: 9, day: 30)])
    payment = payment_new booked_at: '2014-5-1', amount: 17.35
    client_create(id: 1, human_ref: 87, entities: [Entity.new(name: 'Grace')])
      .properties << property_new(human_ref: 63,
                                  account: account_new(charges: [charge],
                                                       payment: payment))
    visit '/clients/1'

    click_on '17.35'
    expect(page).to have_text 'Print Mar 2014'
  end

  def expect_client_ref(ref:)
    expect(page).to have_text ref
  end

  def expect_property_ref(ref:)
    expect(page).to have_text ref
  end

  describe 'appropriate properties message' do
    it 'displays message when client has no properties' do
      client_create id: 1
      visit '/clients/1'

      expect(page).to have_content /The client has no properties./i
    end

    it 'displays no message when client has properties' do
      client_create(id: 1)
        .properties << property_new(human_ref: 6008, account: account_new)
      visit '/clients/1'

      expect(page).to have_text '6008'
      expect(page).to_not have_content /The client has no properties./i
    end

    it 'displays message when client has no properties' do
      skip 'TODO: get test working'
      client_create id: 1
      visit '/clients/1'

      expect(page.text).to match(/The Client has no Mar\/Sep properties./i)
      expect(page.text).to match(/The Client has no Jun\/Dec properties./i)
    end
  end
end
