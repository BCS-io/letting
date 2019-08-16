require 'rails_helper'
require_relative '../../../lib/modules/string_utils'

RSpec.describe Client, type: :model do
  describe 'validations' do
    it('is valid') { expect(client_new).to be_valid }

    describe '#human_ref' do
      it('is needed') { expect(client_new(human_ref: nil)).not_to be_valid }
      it('is a number') { expect(client_new(human_ref: 'nan')).not_to be_valid }
      it 'is unique' do
        client_create human_ref: 1
        expect { client_create human_ref: 1 }
          .to raise_error ActiveRecord::RecordInvalid
      end
      it 'has a name' do
        (client = client_new).entities.destroy_all
        expect(client).not_to be_valid
      end
    end
  end

  describe '.match_by_human_ref' do
    it 'returns arrayed client when matches human_ref' do
      client = client_create human_ref: 10

      expect(described_class.match_by_human_ref 10).to eq [client]
    end

    it 'returns empty array when mismatches human_ref' do
      client_create human_ref: 10

      expect(described_class.match_by_human_ref 8).to be_empty
    end

    it 'returns empty array when matches human_ref but also contains other text' do
      client_create human_ref: 10

      expect(described_class.match_by_human_ref '10 Mr Jones').to be_empty
    end
  end

  describe 'flattening models' do
    it 'returns name' do
      client = client_new entities: [Entity.new(name: 'Strauss')]
      expect(client.full_names).to eq 'Strauss'
    end

    it 'returns no address if null' do
      client = client_new address: nil
      expect(client.address_text).to eq ''
    end

    it 'returns address' do
      client = client_new address: address_new(house_name: 'Hill')
      expect(client.address_text).to eq "Hill\nEdgbaston Road\nBirmingham\nWest Midlands"
    end
  end

  it '#to_s returns client as text' do
    expect(client_new.to_s)
      .to eq "Mr M. Prior\nEdgbaston Road\nBirmingham\nWest Midlands"
  end

  it 'is indexed', elasticsearch: true do
    expect(described_class.__elasticsearch__).to be_index_exists
  end

  describe 'full text .search', :search, elasticsearch: true, type: :model do
    it 'has partial match' do
      client_create entities: [Entity.new(title: 'Mr', initials: 'I', name: 'Bell')]

      described_class.import force: true, refresh: true

      expect(described_class.search('Bel', sort: 'human_ref').results.total).to eq 1
    end

    it 'mismatches human ref' do
      client_create human_ref: '80'
      described_class.import force: true, refresh: true

      expect(described_class.search('80', sort: 'human_ref').count).to eq 0
    end

    it 'matches entity' do
      client_create entities: [Entity.new(title: 'Mr', initials: 'I', name: 'Bell')]
      described_class.import force: true, refresh: true

      expect(described_class.search('Bell', sort: 'human_ref').count).to eq 1
      expect(described_class.search('Bradman', sort: 'human_ref').count).to eq 0
    end

    it 'matches address' do
      client_create address: address_new(house_name: 'Hill', road: 'Edge', town: 'Birm')
      described_class.import force: true, refresh: true

      expect(described_class.search('Edge', sort: 'human_ref').count).to eq 1
      expect(described_class.search('High', sort: 'human_ref').count).to eq 0
    end
  end
end
