require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/entity_fields'

module DB
  describe EntityFields, :import do
    it('title') { expect(EntityFields.new('Mr', 'A', 'Man').title).to eq 'Mr' }
    it 'initials' do
      expect(EntityFields.new('', 'A', 'Man').initials).to eq 'A'
    end
    it('name') { expect(EntityFields.new('Mr', 'A', 'Man').name).to eq 'Man' }

    describe '#update_for' do
      it 'returns the updated structure' do
        client = client_new
        entity = EntityFields.new 'Mr', 'A D', 'Man'

        entity.update_for client.entities.first

        expect(client.full_names).to eq 'Mr A. D. Man'
      end
    end

    describe 'cleaning data' do
      it 'leaves ampersand in middle' do
        entity = EntityFields.new 'Mr', 'A D', 'Woman & Man,'
        expect(entity.name).to eq 'Woman & Man'
      end

      it 'removes trailing ampersand' do
        entity = EntityFields.new 'Mr', 'A D', 'Man&'
        expect(entity.name).to eq 'Man'
      end

      it 'removes trailing ampersand' do
        entity = EntityFields.new 'Mr', 'A D', 'Man,'
        expect(entity.name).to eq 'Man'
      end

      it 'removes prefixed ampersand from title' do
        entity = EntityFields.new '& Mr', 'A D', 'Man,'
        expect(entity.title).to eq 'Mr'
      end

      describe 'title hyphen' do
        it 'eliminates single hyphen title' do
          entity = EntityFields.new '-', 'A D', 'Man,'
          expect(entity.title).to eq ''
        end

        # Don't see this ever happening!
        it 'keeps hyphened-title' do
          entity = EntityFields.new 'Mr-', 'A D', 'Man,'
          expect(entity.title).to eq 'Mr-'
        end
      end

      it 'concats initials to company names' do
        entity = EntityFields.new '', 'A D', 'BCS Ltd'
        expect(entity.name).to eq 'A D BCS Ltd'
      end
    end
  end
end
