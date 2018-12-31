require 'rails_helper'

RSpec.describe 'Client#index', type: :feature do
  before { log_in }

  it 'basic' do
    client_create  \
      human_ref: 111,
      entities: [Entity.new(name: 'Grace')],
      address: address_new(road: 'High St')
    client_create human_ref: 222

    visit '/clients/'

    expect(page.title).to eq 'Letting - Clients'

    expect(page).to have_text '111'
    expect(page).to have_text 'Grace'
    expect(page).to have_text 'High St'
    expect(page).to have_text '222'
  end
end
