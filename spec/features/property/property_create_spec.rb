require 'rails_helper'

#
# Property's route path is to account
# charge tests are in charge_create_spec.rb
#
describe 'Property#create', type: :feature do
  let(:account) { AccountPage.new }
  before(:each) { log_in }

  it 'opens valid page', js: true  do
    account.load
    expect(account.title).to eq 'Letting - New Account'
    expect(page).to have_css('.spec-entity-count', count: 1)
  end

  it '#create', js: true   do
    client_create human_ref: 8008

    account.load
    fill_in_account property_ref: 278, client_ref: 8008
    fill_in_agent address: address_new
    account.button('Create').successful?(self).load id: Property.first.id

    expect_account property_ref: '278', client_ref: 8008
    expect_agent
  end

  it '#creates an account without agent', js: true do
    client_create human_ref: 8008
    account.load

    fill_in_account property_ref: 278, client_ref: '8008'
    account.button('Create').successful?(self).load id: Property.first.id

    expect_account property_ref: '278', client_ref: 8008
  end

  it 'displays form errors' do
    account.load
    account.button 'Create'
    expect(page).to have_css '[data-role="error_messages"]'
  end

  def fill_in_account(property_ref:, client_ref:)
    account.property self, property_id: property_ref, client_id: client_ref
    account.address selector: '#property_address', address: address_new
    account.entity(type: 'property', **person_attributes)
  end

  def fill_in_agent(address:)
    check 'Agent'
    account.address selector: '#agent', address: address
    account.entity(type: 'property_agent_attributes', **company_attributes)
  end

  def expect_account(property_ref:, client_ref:)
    account.expect_property self,
                            property_id: property_ref,
                            client_id: client_ref
    account.expect_address self,
                           type: '#property_address',
                           address: address_new
    account.expect_entity self, type: 'property', **person_attributes
  end

  def expect_agent
    account.expect_address self,
                           type: '#property_agent_address',
                           address: address_new
    account.expect_entity self,
                          type: 'property_agent_attributes',
                          **company_attributes
  end
end
