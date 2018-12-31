require 'rails_helper'

RSpec.describe 'Client#update', type: :feature do
  before { log_in }
  let(:client_page) { ClientPage.new }

  context 'with one entity' do
    before(:each) do
      client_create id: 1, human_ref: 301
      client_page.load id: 1
    end

    it 'opens valid page', js: true do
      expect(client_page.title).to eq 'Letting - Edit Client'
      expect(page).to have_css '.spec-entity-count', count: 1
    end

    # Note ** combines keywords (order + amend_person) - splatted into call
    it 'amends', js: true do
      client_page.click 'Add district'
      client_page.fill_in_client_id 278
      client_page.fill_in_entity order: 0, name: 'Smith'
      client_page.fill_in_address address_attributes town: 'York'
      client_page.button 'Update'
      expect(client_page).to be_successful

      client_page.load id: Client.first.id
      expect(client_page.ref).to eq 278

      expect(client_page.entity(order: 0)).to eq 'Smith'
      expect(client_page.town).to eq 'York'
    end

    it 'displays form errors' do
      client_page.fill_in_client_id(-1) # invalidate_page
      client_page.button 'Update'

      expect(page).to have_css '[data-role="error_messages"]'
    end

    it 'adds a second entity', js: true do
      client_page.click 'Add Person'
      client_page.fill_in_entity order: 1, name: 'Cook'

      client_page.button 'Update'

      expect(client_page).to be_successful

      client_page.load id: 1
      expect(client_page.entity(order: 1)).to eq 'Cook'
    end

    it 'cancel stops amend' do
      client_page.fill_in_entity order: 0, name: 'Smith'
      client_page.click 'Cancel'

      expect(client_page.title).to eq 'Letting - Clients'
      expect(page).to_not have_text 'Smith'
    end
  end

  context 'with two entity' do
    it 'deletes second entity', js: true do
      client_create \
        id: 1,
        human_ref: 301,
        entities: [Entity.new(name: 'Bell'), Entity.new(name: 'Prior')]
      client_page.load id: 1

      client_page.click 'Delete Person'

      client_page.button 'Update'
      expect(client_page).to be_successful
      # expect be_successful required - think allows system to complete update

      expect(Client.first.entities.size).to eq 1
    end

    it 'does not add a third entity', js: true do
      client_create \
        id: 1,
        human_ref: 301,
        entities: [Entity.new(name: 'Bell'), Entity.new(name: 'Prior')]
      client_page.load id: 1
      client_page.click 'Add Person'

      expect(page).to have_css '.spec-entity-count', count: 2
    end
  end
end
