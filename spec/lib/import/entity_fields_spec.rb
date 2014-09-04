require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/entity_fields'
# rubocop: disable Style/Documentation

module DB
  describe EntityFields, :import do

    it 'title' do
      entity = EntityFields.new 'Mr', 'A', 'Man'
      expect(entity.title).to eq 'Mr'
    end

    it 'initials' do
      entity = EntityFields.new 'Mr', 'A D', 'Man'
      expect(entity.initials).to eq 'A D'
    end

    it 'name' do
      entity = EntityFields.new 'Mr', 'A D', 'Man'
      expect(entity.name).to eq 'Man'
    end

    context 'Person' do
      it 'is recognized' do
        entity = EntityFields.new 'Mr', 'A D', 'Man'
        expect(entity).to be_person
      end
    end

    context 'attributes' do
      it 'structure returned' do
        client = client_new
        entity = EntityFields.new 'Mr', 'A D', 'Man'
        entity.update_for client.entities.first
        expect(client.entities.first.title).to eq 'Mr'
        expect(client.entities.first.initials).to eq 'A D'
        expect(client.entities.first.name).to eq 'Man'
      end
    end

    context 'cleaning data' do

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

      it 'concats initials to company names' do
        entity = EntityFields.new '', 'A D', 'BCS Ltd'
        expect(entity.name).to eq 'A D BCS Ltd'
      end
    end
  end
end