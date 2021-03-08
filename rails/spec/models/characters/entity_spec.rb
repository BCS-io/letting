require 'rails_helper'

RSpec.describe Entity, type: :model do
  let(:entity) { described_class.new person_entity_attributes entitieable_id: 1 }

  it('is valid') { expect(entity).to be_valid }

  describe 'validations' do
    describe 'name' do
      it 'presence' do
        entity.name = nil
        expect(entity).not_to be_valid
      end

      it 'is required' do
        entity.name = ''
        expect(entity).not_to be_valid
      end

      it 'has a maximum' do
        entity.name = 'a' * 65
        expect(entity).not_to be_valid
      end
    end

    it 'title has a max' do
      entity.title = 'a' * 11
      expect(entity).not_to be_valid
    end

    it 'initials has a max' do
      entity.initials = 'a' * 11
      expect(entity).not_to be_valid
    end
  end

  describe 'methods' do
    describe '#empty?' do
      let(:entity) { described_class.new }

      it('is empty when new') { expect(entity).to be_empty }

      it 'fills on assigining noted attributes' do
        entity.name = 'Bob'
        expect(entity).to be_present
      end

      it 'remains empty on assinging ignored attributes' do
        entity.id = 8
        expect(entity).to be_empty
      end
    end

    describe '#full_name' do
      it 'with initials' do
        expect(entity.full_name).to eq 'Mr W. G. Grace'
      end

      it 'without initials' do
        entity.initials = nil
        expect(entity.full_name).to eq 'Mr Grace'
      end
    end
  end
end
