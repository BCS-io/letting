require 'rails_helper'

RSpec.describe Entity, type: :model do
  let(:entity) { Entity.new person_entity_attributes entitieable_id: 1 }
  it('is valid') { expect(entity).to be_valid }

  describe 'validations' do
    describe 'name' do
      it 'presence' do
        entity.name = nil
        expect(entity).to_not be_valid
      end

      it 'is required' do
        entity.name = ''
        expect(entity).to_not be_valid
      end

      it 'has a maximum' do
        entity.name = 'a' * 65
        expect(entity).to_not be_valid
      end
    end

    it 'title has a max' do
      entity.title = 'a' * 11
      expect(entity).to_not be_valid
    end

    it 'initials has a max' do
      entity.initials = 'a' * 11
      expect(entity).to_not be_valid
    end
  end

  describe 'methods' do
    context 'new entity' do
      let(:entity) { Entity.new }

      context '#empty?' do
        it('is empty') { expect(entity).to be_empty }

        it 'with noted attribute not empty' do
          entity.name = 'Bob'
          expect(entity).to be_present
        end

        it 'with ignored attribute empty' do
          entity.id = 8
          expect(entity).to be_empty
        end
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
