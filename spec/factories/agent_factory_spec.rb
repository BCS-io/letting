require 'rails_helper'

describe 'Agent Factory' do
  describe 'default' do
    it('is valid') { expect(agent_new).to be_valid }
    it 'has address' do
      expect(agent_new.to_billing)
        .to eq "Mr M. Prior\nEdgbaston Road\nBirmingham\nWest Midlands"
    end
    it('has road') { expect(agent_new.address.road).to eq 'Edgbaston Road' }
  end

  describe 'overrides' do
    it 'alters entity' do
      entities = [Entity.new(title: 'Mr', initials: 'I', name: 'Bell')]
      expect(agent_new(entities: entities).to_billing)
        .to eq "Mr I. Bell\nEdgbaston Road\nBirmingham\nWest Midlands"
    end

    it 'alters address' do
      agent = agent_new address: address_new(road: 'Wiggiton')
      expect(agent.to_billing)
        .to eq "Mr M. Prior\nWiggiton\nBirmingham\nWest Midlands"
    end
  end
end
