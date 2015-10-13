require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/import_agent'

module DB
  describe ImportAgent, :import do
    let!(:property) do
      property_create human_ref: 122
    end

    def row
      %q(122, Mr, B P, Example, Mrs, A N, Other,) +
        %q(1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, )
    end

    it 'One row' do
      expect(Agent.first.authorized).to be false
      expect { import_agent row }.to_not change(Agent, :count)
      expect(Agent.first.authorized).to be true
    end

    # contact entities test suite in import_contact_entity_spec
    #
    it 'Property has two entities' do
      import_agent row
      expect(Agent.first.full_names).to \
        eq 'Mr B. P. Example & Mrs A. N. Other'
    end

    context 'filter' do
      it 'allows within range' do
        import_agent row, range: 122..122
        expect(Agent.first.authorized).to be true
      end

      it 'filters if out of range' do
        import_agent row, range: 120..121
        expect(Agent.first.authorized).to be false
      end
    end

    def import_agent row, **args
      ImportAgent.import parse(row), args
    end

    def parse row_string
      CSV.parse(row_string,
                headers: FileHeader.agent,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
