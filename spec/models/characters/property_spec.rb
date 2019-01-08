require 'rails_helper'

RSpec.describe Property, type: :model do
  it('is valid') { expect(property_new).to be_valid }

  describe 'validations' do
    describe '#human_ref' do
      it('is present') { expect(property_new(human_ref: nil)).to_not be_valid }
      it('is a number') { expect(property_new(human_ref: 'n')).to_not be_valid }
      it 'is unique' do
        property_create human_ref: 8000
        expect { property_create human_ref: 8000 }
          .to raise_error ActiveRecord::RecordInvalid
      end
    end
    describe 'presence' do
      it 'agent' do
        (property = property_new).agent = nil
        expect(property).to_not be_valid
      end
      it 'entities' do
        expect(property_new occupiers: []).to_not be_valid
      end
    end
  end

  describe 'Methods' do
    describe '#invoice' do
      describe '[:billing_address]' do
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
  end

  describe 'class methods' do
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

        expect(Property.quarter_day_in 3).to eq [property]
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

        expect(Property.quarter_day_in 3).to eq []
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

  it 'should be indexed', elasticsearch: true do
    expect(Property.__elasticsearch__.index_exists?).to be_truthy
  end

  describe 'full text .search', elasticsearch: true do
    before :each do
      agent = agent_new authorized: true,
                        entities: [Entity.new(name: 'Bel')],
                        address: address_new(road: 'Old', town: 'York')
      property_create address: address_new(house_name: 'Hill'),
                      agent: agent
      Property.import force: true, refresh: true
    end

    it 'not human id' do
      expect(Property.search('2002', sort: 'human_ref').results.total).to eq 0
    end
    it 'names' do
      expect(Property.search('Grac', sort: 'human_ref').count).to eq 1
    end
    it 'house' do
      expect(Property.search('Hil', sort: 'human_ref').count).to eq 1
    end
    it 'roads' do
      expect(Property.search('Edg', sort: 'human_ref').count).to eq 1
    end
    it 'towns' do
      expect(Property.search('Bir', sort: 'human_ref').count).to eq 1
    end
    it 'agent name' do
      expect(Property.search('Bel', sort: 'human_ref').count).to eq 1
    end
    it 'agent town' do
      expect(Property.search('Yor', sort: 'human_ref').count).to eq 1
    end
  end
end
