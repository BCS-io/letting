require 'rails_helper'

RSpec.describe 'Client#create', type: :system do
  before { log_in }
  let(:client_page) { ClientPage.new }

  it 'opens valid page', js: true do
    client_page.load

    expect(client_page.title).to eq 'Letting - New Client'
    expect(page).to have_css '.spec-entity-count', count: 1
  end

  it 'can be added', js: true, elasticsearch: true do
    client_page.load
    client_page.click 'Add district'
    client_page.fill_in_client_id 278
    client_page.fill_in_entity order: 0, name: 'Bell'
    client_page.fill_in_address address_attributes(town: 'York')
    client_page.button 'Create'
    expect(client_page).to be_successful

    client_page.load id: Client.first.id
    expect(client_page.ref).to eq 278
    expect(client_page.entity(order: 0)).to eq 'Bell'
    expect(client_page.town).to eq 'York'
  end

  it 'displays form errors' do
    client_page.load
    client_page.button 'Create'

    expect(page).to have_css '[data-role="error_messages"]'
  end

  it 'can cancel' do
    client_page.load
    client_page.fill_in_entity order: 0, name: 'Bell'

    client_page.click 'Cancel'

    expect(client_page.title).to eq 'Letting - Clients'
    expect(page).to_not have_text 'Bell'
  end

  it 'has add and remove actions', js: true do
    client_page.load
    client_page.click 'Add Person'

    expect(page).to have_css '.spec-entity-count', count: 2
    client_page.fill_in_entity order: 1, name: 'Cook'

    client_page.click 'Delete Person'

    expect(page).to have_css '.spec-entity-count', count: 1
  end
end
