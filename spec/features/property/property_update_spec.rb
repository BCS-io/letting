require 'rails_helper'

#
# Property's route path is to account
# Tests for creating charges onto a property have been moved to
# charge_create_spec.rb
#
describe 'Property#Update', type: :feature do
  let(:account) { AccountPage.new }

  context 'Agentless' do
    before(:each) do
      log_in
      property_create id: 1,
                      human_ref: 80,
                      account: account_new,
                      client: client_new(human_ref: 90)
    end

    it 'opens valid page', js: true do
      account.load id: 1
      expect(account.title).to eq 'Letting - Edit Account'
      account.expect_property self,
                              property_id: '80',
                              client_id: Client.first.id
      account.expect_address self,
                             type: '#property_address',
                             address: address_new
      account.expect_entity self, type: 'property', **person_attributes
    end

    it 'updates account', js: true do
      new_client = client_create(human_ref: 101)
      account.load id: 1
      account.property property_id: '81', client_ref: '101'
      account.address selector: '#property_address', address: address_new
      account.entity type: 'property', **company_attributes
      account.button('Update').successful?(self).load id: 1
      account.expect_property self, property_id: '81', client_id: new_client.id
      account.expect_address self,
                             type: '#property_address',
                             address: address_new
      account.expect_entity self, type: 'property', **company_attributes
    end

    it 'adds agent', js: true do
      account.load id: 1
      check 'Agent'
      account.address selector: '#agent', address: address_new
      account.entity type: 'property_agent_attributes', **company_attributes

      account.button('Update').successful?(self).load id: 1
      expect(find_field('Agent')).to be_checked
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new
      account.expect_entity self,
                            type: 'property_agent_attributes',
                            **company_attributes
    end

    it 'displays form errors' do
      account.load id: 1

      account.address selector: '#property_address',
                      address: address_new(road: '')
      account.button 'Update'
      expect(page).to have_css '[data-role="error_messages"]'
    end
  end

  context 'Agentless with charge' do
    before { log_in }

    it 'can be set to dormant', js: true do
      property_create \
        id: 1, account: account_new(charges: [charge_new(activity: 'active')])
      account.load id: 1
      activity =
        '//*[@id="property_account_attributes_charges_attributes_0_activity"]'
      expect(find(:xpath, activity).value).to eq 'active'

      find(:xpath, activity).select 'dormant'

      account.button('Update').successful?(self).load id: 1
      expect(find(:xpath, activity).value).to eq 'dormant'
    end
  end

  context 'with Agent' do
    before(:each) do
      log_in
      agent = agent_new entities: [Entity.new(name: 'Willis')],
                        address: address_new(road: 'Wiggiton')

      property_create id: 1, account: account_new, agent: agent
      account.load id: 1
    end

    it 'opens property with agent', js: true  do
      expect(find_field('Agent')).to be_checked
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new(road: 'Wiggiton')
      account.expect_entity(self,
                            type: 'property_agent_attributes',
                            name: 'Willis')
    end

    it 'updates agent' do
      account.address(selector: '#agent', address: address_new)
      account.entity(type: 'property_agent_attributes', **company_attributes)

      account.button('Update').successful?(self).load id: 1
      account.expect_address self,
                             type: '#property_agent_address',
                             address: address_new
      account.expect_entity(self,
                            type: 'property_agent_attributes',
                            **company_attributes)
    end

    it 'removes agent' do
      uncheck 'Agent'
      account.button('Update').successful?(self).load id: 1
      expect(find_field('Agent')).to_not be_checked
    end
  end
end
