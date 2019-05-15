require 'rails_helper'

RSpec.describe Agent, type: :model do
  it('is valid') { expect(agent_new).to be_valid }

  describe 'flattening models' do
    it 'returns name' do
      agent = agent_new entities: [Entity.new(name: 'Strauss')]
      expect(agent.full_names).to eq 'Strauss'
    end

    it 'returns no address if null' do
      agent = agent_new address: nil
      expect(agent.address_text).to eq ''
    end

    it 'returns address' do
      agent = agent_new address: address_new(house_name: 'Hill')
      expect(agent.address_text).to eq "Hill\nEdgbaston Road\nBirmingham\nWest Midlands"
    end
  end

  context 'when authorized' do
    it 'clear_up only removes dummy entity' do
      (agent = agent_new).authorized = true
      agent.clear_up_form
      expect(saveable_entities(agent.entities)).to eq(1)
    end
  end

  context 'when unauthorized' do
    describe 'clear_up form' do
      it 'removes all entities' do
        (agent = agent_new).authorized = false
        agent.clear_up_form
        expect(saveable_entities(agent.entities)).to eq(0)
      end

      it 'remains valid' do
        (agent = agent_new).authorized = false
        agent.clear_up_form
        expect(agent).to be_valid
      end
    end
  end

  def saveable_entities entities
    entities.reject(&:marked_for_destruction?).size
  end
end
