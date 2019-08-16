require 'rails_helper'

RSpec.describe 'Client Factory' do
  describe 'client_new' do
    describe 'defaults' do
      it('is valid') { expect(client_new).to be_valid }
      it('no id') { expect(client_new.id).to eq nil }
      it('has human_ref') { expect(client_new.human_ref).to eq 354 }
      it('has entity') { expect(client_new.full_names).to eq 'Mr M. Prior' }
      it('has address') { expect(client_new.address.town).to eq 'Birmingham' }
    end

    describe 'overrides' do
      it 'alters human_ref' do
        expect(client_new(human_ref: 620).human_ref).to eq 620
      end
    end

    describe 'adds' do
      it 'entities' do
        entities = [Entity.new(title: 'Mr', initials: 'I', name: 'Bell')]
        expect(client_new(entities: entities).full_names).to eq 'Mr I. Bell'
      end

      it 'address' do
        address = address_new road: 'High St'
        expect(client_new(address: address).address.road).to eq 'High St'
      end

      it 'properties' do
        expect(client_new(properties: [property_new])
                 .properties.first.human_ref).to eq 2002
      end
    end
  end

  describe 'client_create' do
    it 'is created' do
      expect { client_create }.to change(Client, :count).by(1)
    end

    describe 'adds' do
      it 'properties' do
        expect { client_create properties: [property_new] }
          .to change(Property, :count).by(1)
      end
    end
  end
end
