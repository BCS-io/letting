require 'rails_helper'
require 'csv'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_client'

module DB
  describe 'ImportContactEntity', :import do
    def row
      %q(11,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
        %q(Example Street, ,Example Town,  Example County,  E10 7EX)
    end

    def updated_row
      %q(11,  Mr,  E, Changed, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
        %q(Example Street, Example District,Example Town,  Example County,) +
        %q(E10 7EX)
    end

    def one_entity_fields
      %q(11,  Mr,  D, Example, , , , 1, ExampleHouse,  2, ) +
        %q(Example Street, ,Example Town,  Example County,  E10 7EX)
    end

    it 'One row, 2 Entities' do
      expect { import_client row }.to change(Entity, :count).by 2
    end

    it 'Not double import' do
      expect { import_client row }.to change(Entity, :count).by 2
      expect { import_client row }.to_not change(Entity, :count)
    end

    it 'adds one entity when second entity blank' do
      expect { import_client one_entity_fields }.to change(Entity, :count).by 1
    end

    it 'ordered by creation' do
      import_client row
      expect(Client.first.entities[0].created_at).to be <
                                                     Client.first.entities[1].created_at
    end

    context 'multiple imports' do
      it 'updated changed entities' do
        import_client row
        import_client updated_row
        expect(Client.first.full_names).to \
          eq 'Mr E. Changed & Mrs A. N. Other'
      end

      it 'removes deleted second entities' do
        import_client row
        expect { import_client one_entity_fields }
          .to change(Entity, :count).by(-1)
      end
    end

    def import_client row, **args
      ImportClient.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.client,
                header_converters: :symbol,
                converters: ->(field) { field ? field.strip : nil })
    end
  end
end
