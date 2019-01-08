require 'rails_helper'
require_relative '../../../lib/modules/string_utils'

RSpec.describe Client, type: :model do
  describe 'validations' do
    it('is valid') { expect(client_new).to be_valid }

    describe '#human_ref' do
      it('is needed') { expect(client_new(human_ref: nil)).to_not be_valid }
      it('is a number') { expect(client_new(human_ref: 'nan')).to_not be_valid }
      it 'is unique' do
        client_create human_ref: 1
        expect { client_create human_ref: 1 }
          .to raise_error ActiveRecord::RecordInvalid
      end
      it 'has a name' do
        (client = client_new).entities.destroy_all
        expect(client).to_not be_valid
      end
    end
  end

  describe '.find_by_human_ref' do
    it 'finds client by human_ref' do
      client_create human_ref: 10
      expect(Client.find_by_human_ref(10).human_ref).to eq 10
    end

    it 'does not finds client when missing human_ref' do
      expect(Client.find_by_human_ref 10).to be_nil
    end

    it 'does not finds client when missing human_ref' do
      client_create human_ref: 10

      expect(Client.find_by_human_ref '10 High Street').to be_nil
    end
  end

  it '#to_s returns client as text' do
    expect(client_new.to_s)
      .to eq "Mr M. Prior\nEdgbaston Road\nBirmingham\nWest Midlands"
  end

  it 'should be indexed', elasticsearch: true do
    expect(Client.__elasticsearch__.index_exists?).to be_truthy
  end

  describe 'full text .search', :search, elasticsearch: true, type: :model do
    it 'has partial match' do
      client_create entities: [Entity.new(title: 'Mr', initials: 'I', name: 'Bell')]

      Client.import force: true, refresh: true

      expect(Client.search('Bel', sort: 'human_ref').results.total).to eq 1
    end

    it 'mismatches human ref' do
      client_create human_ref: '80'
      Client.import force: true, refresh: true

      expect(Client.search('80', sort: 'human_ref').count).to eq 0
    end

    it 'matches entity' do
      client_create entities: [Entity.new(title: 'Mr', initials: 'I', name: 'Bell')]
      Client.import force: true, refresh: true

      expect(Client.search('Bell', sort: 'human_ref').count).to eq 1
      expect(Client.search('Bradman', sort: 'human_ref').count).to eq 0
    end

    it 'matches address' do
      client_create address: address_new(house_name: 'Hill', road: 'Edge', town: 'Birm')
      Client.import force: true, refresh: true

      expect(Client.search('Edge', sort: 'human_ref').count).to eq 1
      expect(Client.search('High', sort: 'human_ref').count).to eq 0
    end
  end
end
