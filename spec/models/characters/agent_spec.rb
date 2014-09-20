require 'rails_helper'

describe Agent, type: :model do

  it('is valid') { expect(agent_new).to be_valid }

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
