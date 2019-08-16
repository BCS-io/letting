require 'rails_helper'

RSpec.describe PropertyDecorator do
  let(:property) { described_class.new property_new }

  let(:house) do
    property.address.flat_no = ''
    property.address.house_name = ''
    property
  end

  describe '#client_ref' do
    it 'nil when client unknown' do
      property.client = nil
      expect(property.client_ref).to eq nil
    end

    it 'client_ref when known' do
      property.client = client_new human_ref: 8008
      expect(property.client_ref).to eq 8008
    end
  end

  it 'writes flat name' do
    expect(property.occupiers).to eq 'Mr W. G. Grace'
  end

  describe 'Agent' do
    context 'with agent' do
      it 'name returned' do
        agent = agent_new entities: [Entity.new(name: 'Willis')]
        decorator = described_class.new property_create agent: agent
        expect(decorator.agent_name).to eq 'Willis'
      end

      it 'address returned' do
        agent = agent_new address: address_new(road: 'Wiggiton')
        decorator = described_class.new property_create agent: agent
        expect(decorator.agent.address.text)
          .to eq "Wiggiton\nBirmingham\nWest Midlands"
      end
    end

    context 'without agent' do
      it 'name missing' do
        expect(property.agent_name).to eq 'None'
      end

      it 'address missing' do
        expect(property.agent_address_lines).to eq '-'
      end
    end
  end
end
