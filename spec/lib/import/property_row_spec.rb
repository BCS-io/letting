require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/property_row'

module DB
  RSpec.describe PropertyRow, :import do
    let(:row) { PropertyRow.new parse_line property_row }

    context 'readers' do
      it 'human_ref' do
        expect(row.human_ref).to eq 122
      end
    end

    context 'methods' do
      context '#client_id' do
        it 'found when present' do
          client = client_create human_ref: 11
          expect(row.client_id).to eq client.id
        end

        it 'errors when missing' do
          expect { row.client_id }.to raise_error ClientRefUnknown
        end
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.property,
                     header_converters: :symbol,
                     converters: ->(field) { field ? field.strip : nil })
    end

    def property_row
      %q(122, 2013-02-26 12:35:00, Mr, A N, Example, Mrs, A N, Other,) +
        %q(1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ) +
        %q(11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0)
    end
  end
end
