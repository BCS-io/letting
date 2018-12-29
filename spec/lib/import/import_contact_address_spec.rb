require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_client'

module DB
  describe 'ImportContactAddress', :import do
    def row
      %q(11,  Mr,  D, Example, Mrs, A N, Other, 14a, ExampleHouse,  2, ) +
        %q(Example Street, Example District ,Example Town,  Example County,) +
        %q(E10 7EX)
    end

    it 'Flat No Imported' do
      import_client row
      expect(Address.first.flat_no).to eq '14a'
    end

    it 'House Imported' do
      import_client row
      expect(Address.first.house_name).to eq 'ExampleHouse'
    end

    it 'Road No' do
      import_client row
      expect(Address.first.road_no).to eq '2'
    end

    it 'Road' do
      import_client row
      expect(Address.first.road).to eq 'Example Street'
    end

    it 'district' do
      import_client row
      expect(Address.first.district).to eq 'Example District'
    end

    it 'town' do
      import_client row
      expect(Address.first.town).to eq 'Example Town'
    end

    it 'county' do
      import_client row
      expect(Address.first.county).to eq 'Example County'
    end

    it 'postcode' do
      import_client row
      expect(Address.first.postcode).to eq 'E10 7EX'
    end

    def import_client row, **args
      ImportClient.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.client,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil })
    end
  end
end
