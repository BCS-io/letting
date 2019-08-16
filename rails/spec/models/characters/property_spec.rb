require 'rails_helper'

RSpec.describe Property, type: :model do
  it('is valid') { expect(property_new).to be_valid }

  describe 'validations' do
    describe '#human_ref' do
      it('is present') { expect(property_new(human_ref: nil)).not_to be_valid }
      it('is a number') { expect(property_new(human_ref: 'n')).not_to be_valid }
      it 'is unique' do
        property_create human_ref: 8000
        expect { property_create human_ref: 8000 }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end

    describe 'presence' do
      it 'agent' do
        (property = property_new).agent = nil
        expect(property).not_to be_valid
      end
      it 'entities' do
        expect(property_new occupiers: []).not_to be_valid
      end
    end
  end

  describe 'Methods' do
    describe '#invoice - [:billing_address]' do
      context 'without agent' do
        property = nil
        before do
          agent = agent_new authorized: false,
                            entities: [Entity.new(name: 'Bel')],
                            address: address_new(road: 'Old', town: 'York')
          property = property_new occupiers: [Entity.new(name: 'Grace')],
                                  address: address_new(road: 'N', town: 'Bm'),
                                  agent: agent
        end

        it 'displays property text' do
          expect(property.invoice[:billing_address])
            .to eq "Grace\nN\nBm\nWest Midlands"
        end
      end

      context 'with agent' do
        property = nil
        before do
          agent = agent_new authorized: true,
                            entities: [Entity.new(name: 'Bel')],
                            address: address_new(road: 'Old', town: 'York')
          property = property_new occupiers: [Entity.new(name: 'Grace')],
                                  address: address_new(road: 'N', town: 'Bm'),
                                  agent: agent
        end

        it 'displays property text' do
          expect(property.invoice[:billing_address])
            .to eq "Bel\nOld\nYork\nWest Midlands"
        end
      end
    end
  end

  describe 'class methods' do
    describe 'match_by_human_ref' do
      it 'returns arrayed property when matches human_ref' do
        property = property_create human_ref: 10
        expect(described_class.match_by_human_ref 10).to eq [property]
      end

      it 'returns empty array when mismatches human_ref' do
        property_create human_ref: 10
        expect(described_class.match_by_human_ref 8).to be_empty
      end

      it 'returns empty array when matches human ref but also contains other text' do
        property_create human_ref: 10

        expect(described_class.match_by_human_ref '10 Mr Jones').to be_empty
      end
    end

    describe 'quarter_day_in' do
      it 'matches properties with quarter day charges' do
        property = property_create(
          account: account_create(
            charges: [charge_new(
              cycle: cycle_new(name: 'Feb-due-on',
                               due_ons: [DueOn.new(month: 3, day: 4),
                                         DueOn.new(month: 9, day: 4)])
            )]
          )
        )

        expect(described_class.quarter_day_in 3).to eq [property]
      end

      it 'rejects properties without quarter day charges' do
        property_create(
          account: account_create(
            charges: [charge_new(
              cycle: cycle_new(name: 'Feb-due-on',
                               due_ons: [DueOn.new(month: 2, day: 4),
                                         DueOn.new(month: 9, day: 4)])
            )]
          )
        )

        expect(described_class.quarter_day_in 3).to eq []
      end
    end
  end

  describe 'flattening models' do
    it 'returns abridged version of address' do
      p = property_create address: address_new(road: 'Edge', town: 'Brum', county: 'West')
      expect(p.abridged_text).to eq "Edge\nBrum"
    end

    it 'returns tenants' do
      p = property_create occupiers: [Entity.new(name: 'Strauss')]
      expect(p.full_names).to eq 'Strauss'
    end

    it 'returns address' do
      p = property_create address: address_new(house_name: 'Hill')
      expect(p.address_text).to eq "Hill\nEdgbaston Road\nBirmingham\nWest Midlands"
    end
  end

  it 'is indexed', elasticsearch: true do
    expect(described_class.__elasticsearch__).to be_index_exists
  end

  describe 'full text .search', elasticsearch: true do
    it 'matches partial match' do
      property_create address: address_new(house_name: 'Hill')
      described_class.import force: true, refresh: true

      expect(described_class.search('Hil', sort: 'human_ref').count).to eq 1
    end

    it 'mismatches human ref' do
      property_create human_ref: 2002
      described_class.import force: true, refresh: true

      expect(described_class.search('2002', sort: 'human_ref').results.total).to eq 0
    end

    it 'matches address' do
      property_create address: address_new(house_name: 'Hill')
      described_class.import force: true, refresh: true

      expect(described_class.search('Hil', sort: 'human_ref').count).to eq 1
      expect(described_class.search('Edgeware', sort: 'human_ref').count).to eq 0
    end

    it 'matches agent name' do
      agent = agent_new authorized: true, entities: [Entity.new(name: 'Bel')]
      property_create agent: agent
      described_class.import force: true, refresh: true

      expect(described_class.search('Bel', sort: 'human_ref').count).to eq 1
      expect(described_class.search('Bradman', sort: 'human_ref').count).to eq 0
    end

    it 'matches agent town' do
      agent = agent_new authorized: true,
                        address: address_new(road: 'Old', town: 'York')
      property_create agent: agent
      described_class.import force: true, refresh: true

      expect(described_class.search('Yor', sort: 'human_ref').count).to eq 1
      expect(described_class.search('London', sort: 'human_ref').count).to eq 0
    end
  end
end
