require 'rails_helper'
require 'csv'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_client'

module DB
  describe ImportClient, :import do
    def row
      %q(11, Mr, A, One, Mrs, B, Two, 1, House, 2, ) +
        %q(Street, ,Town, County, E10 7EX)
    end

    def updated_row
      %q(11,  Mr,  C, Uno, Mrs, D, Dos, 1, House,  2, ) +
        %q(Street, District, Town, County, E10 7EX)
    end

    it 'One row' do
      expect { import_client row }.to change(Client, :count).by 1
    end

    it 'has two entities' do
      import_client row

      expect(Client.first.entities[0].full_name).to eq 'Mr A. One'
      expect(Client.first.entities[1].full_name).to eq 'Mrs B. Two'
    end

    it 'updated changed entities' do
      import_client row

      import_client updated_row

      expect(Client.first.entities[0].full_name).to eq 'Mr C. Uno'
      expect(Client.first.entities[1].full_name).to eq 'Mrs D. Dos'
    end

    it 'Not double import' do
      import_client row
      expect { import_client row }.to_not change(Client, :count)
    end

    def import_client row, **args
      ImportClient.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.client,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
