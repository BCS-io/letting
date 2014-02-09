require 'spec_helper'

describe Agent do

  it('is valid') { expect(agent_new).to be_valid }

  context 'new agent' do
    let(:new_agent) { Agent.new }
    it('has nil address') { expect(new_agent.address).to be_nil }
    it('has no entities') { expect(new_agent.entities.size).to eq 0 }

    context 'unauthorized and prepared' do
      before :each do
        new_agent.prepare_for_form
      end
      it 'has entities but all blank' do
        expect(new_agent.entities).to have(2).items
        expect(new_agent.entities).to be_all(&:empty?)
      end
    end
  end

  context 'prepared' do
    let(:agent) do
      agent = nameless_agent
      agent.entities.build person_entity_attributes
      expect(agent.entities).to have(1).item
      agent.prepare_for_form
      agent
    end

    it 'has dummy entity' do
      expect(agent.entities).to have(2).items
    end

    context 'when authorized' do
      before(:each) { agent.authorized = true }

      it 'clear_up only removes dummy entity' do
        agent.clear_up_form
        expect(saveable_entities(agent.entities)).to have(1).items
      end
    end

    context 'when unauthorized' do
      before(:each) { agent.authorized = false }

      describe 'clear_up form' do
        it 'removes all entities' do
          agent.clear_up_form
          expect(saveable_entities(agent.entities)).to have(0).items
        end

        it 'remains valid' do
          agent.clear_up_form
          expect(agent).to be_valid
        end
      end
    end
  end

  def saveable_entities entities
    entities.reject(&:marked_for_destruction?)
  end
end