require 'rails_helper'

describe 'Property Factory' do
  describe 'new' do
    describe 'default' do
      it('is valid') { expect(property_new).to be_valid }
      it('has human_ref') { expect(property_new.human_ref).to eq 2002 }

      describe 'makes' do
        it 'address' do
          expect(property_new.address).to_not be_nil
        end
      end
    end

    describe 'overrides' do
      it 'alters human_ref' do
        expect(property_new(human_ref: 8).human_ref).to eq 8
      end
      it 'alters occupiers' do
        property = property_new occupiers: [Entity.new(name: 'Prior')]
        expect(property.occupiers).to eq 'Prior'
      end
      it 'alters address' do
        property = property_new human_ref: 3001,
                                address: address_new(road: 'Hill')
        expect(property.address.road).to eq 'Hill'
      end
    end
    describe 'adds' do
      it 'can add account' do
        expect(property_new(account: account_new).account).to_not be_nil
      end

      it 'can add agent' do
        property_create agent: agent_new(entities: [Entity.new(name: 'Prior')],
                                         address: address_new(road: 'New',
                                                              town: 'Brum',
                                                              county: 'West'))
        expect(Property.first.agent.to_billing).to eq "Prior\nNew\nBrum\nWest"
      end
    end
  end

  describe 'create' do
    it('alters id') { expect(property_create(id: 2).id).to eq 2 }

    describe 'default' do
      it('is created') { expect(property_create).to be_valid }
      it('has human_ref') { expect(property_create.human_ref).to eq 2002 }
    end

    describe 'overrides' do
      it 'alters human_ref' do
        expect(property_create(human_ref: 8).human_ref).to eq 8
      end
    end

    describe 'adds' do
      it 'can add account' do
        expect { property_create account: account_new }
          .to change(Account, :count).by(1)
      end

      it 'can add agent' do
        property_create agent: agent_new(entities: [Entity.new(name: 'Prior')])
        expect(Property.first.agent.full_names).to eq 'Prior'
      end
    end
  end
end
