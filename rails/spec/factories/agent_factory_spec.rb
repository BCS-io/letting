require 'rails_helper'

RSpec.describe 'Agent Factory' do
  describe 'agent_new' do
    describe 'defaults' do
      it('is valid') { expect(agent_new).to be_valid }

      it 'has address' do
        expect(agent_new.to_billing)
          .to eq "Mr M. Prior\nEdgbaston Road\nBirmingham\nWest Midlands"
      end

      it('has road') { expect(agent_new.address.road).to eq 'Edgbaston Road' }
    end
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

    it 'can have nil address' do
      agent = agent_new address: nil
      expect(agent.address).to be_nil
    end
  end
end
