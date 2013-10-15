require 'spec_helper'
require_relative 'client_shared'
require_relative '../shared/entity'

describe Client do
  before(:each) { log_in }

  context '#updates' do
    let(:click_update_client) { ClientUpdatePage.new }
    before(:each) do
      client_create! id: 1
      navigate_to_edit_page
    end

    it 'basic', js: true do
      validate_page
      fill_in_form
      click_update_client.click_update_client
      expect_client_index
      navigate_to_client_page '278'
      expect_client_edit
    end

    it 'has validation' do
      invalidate_page
      click_update_client.click_update_client
      expect(current_path).to eq '/clients/1'
      expect(page).to have_text /The client could not be saved./i
    end

    it 'adds second entity', js: true do
      click_update_client.click('Add Person')
      click_update_client.fill_in_2nd_ent_form
      click_update_client.click_update_client
      expect(current_path).to eq '/clients'
      click_update_client.click_view
      expect(page).to have_text 'Test'
    end

    it 'shows person', js: true do
      expect(page).to have_text 'Person or company'
      expect(find_field('Name').value).to have_text 'Grace'
      expect(page).to have_text 'Initials'
    end

    it 'cancel does not change client' do
      click_update_client.fill_in_cancel_form
      expect(current_path).to eq '/clients'
      expect(page).to have_text 'Grace'
    end
  end

  context '#updates' do
    let(:click_update_client) { ClientUpdatePage.new }

    it '#updates shows company', js: true do
      client_company_create! human_id: 111
      navigate_to_edit_page
      expect(page).to have_text 'Company or person'
      expect(find_field('Name').value).to have_text 'ICC'
      expect(page).to_not have_text 'Initials'
    end

    it '#updates deletes a second entity', js: true do
      client_two_entities_create! human_id: 8008
      navigate_to_edit_page
      click_update_client.click('X')
      click_update_client.click_update_client
      click_update_client.click_view
      expect(page).to have_text 'Properties Owned'
      expect(page).to have_text 'Grace'
      expect(page).to_not have_text 'Knutt'
    end
  end

  def navigate_to_edit_page
    visit '/clients/'
    click_on 'Edit'
  end

  def validate_page
    expect(current_path).to eq '/clients/1/edit'
    expect_client_has_original_attributes
    expect_address_has_original_attributes
    expect_entity_has_original_attributes
  end

  def expect_client_has_original_attributes
    expect(find_field('Client ID').value).to have_text '8008'
  end

  def expect_address_has_original_attributes
    within_fieldset 'client_address' do
      expect_address_edgbaston_by_field
    end
  end

  def expect_entity_has_original_attributes
    expect(page.all('h3', text: 'Person').count).to eq 1
    within_fieldset 'client_entity_0' do
      expect_entity_wg_grace_by_field
    end
  end

  def expect_client_index
    expect(current_path).to eq '/clients'
    expect(page).to have_text /client successfully updated!/i
    expect_client_data_changed
  end

  def expect_client_edit
    expect(find_field('Town').value).to have_text 'Nottingham'
  end

    def expect_client_data_changed
      expect(page).to_not have_text '8008'
      expect(page).to have_text '278'
      expect(page).to_not have_text '294'
      expect(page).to have_text '63c'
    end

end
