require 'rails_helper'

describe 'Client#create', type: :feature do
  before(:each) { log_in }
  let(:client_page) { ClientPage.new }

  def new_person **overrides
    { title: 'Mr', initials: 'I R', name: 'Bell' }.merge overrides
  end

  def add_person **overrides
    { title: 'Mr', initials: 'A', name: 'Cook' }.merge overrides
  end

  it 'opens valid page', js: true  do
    client_page.load

    expect(current_path).to eq '/clients/new'
    expect(page).to have_css '.spec-entity-count', count: 1
  end

  it 'can be added', js: true do
    client_page.load
    client_page.click 'Add district'
    client_page.fill_in_client_id 278
    client_page.fill_in_entity order: 0, **new_person(name: 'Bell')
    client_page.fill_in_address address_attributes(town: 'York')
    client_page.button 'Create'
    expect(client_page).to be_successful

    client_page.load id: Client.first.id
    expect(client_page.ref).to eq 278
    expect(client_page.entity(order: 0)).to eq 'Mr I R Bell'
    client_page.expect_address self, address_attributes(town: 'York')
  end

  it 'displays form errors' do
    client_page.load
    client_page.button 'Create'
    expect(page).to have_css '[data-role="errors"]'
  end

  it 'can cancel' do
    client_page.load
    client_page.fill_in_entity order: 0, **new_person(name: 'Bell')

    client_page.click 'Cancel'

    expect(client_page.title).to eq 'Letting - Clients'
    expect(page).to_not have_text 'Bell'
  end

  it 'has add and remove actions', js: true do
    client_page.load
    client_page.click 'Add Person'

    expect(page).to have_css '.spec-entity-count', count: 2
    client_page.fill_in_entity order: 1, **add_person

    client_page.click 'Delete Person'

    expect(page).to have_css '.spec-entity-count', count: 1
  end
end
