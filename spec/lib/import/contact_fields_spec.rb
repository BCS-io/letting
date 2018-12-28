require 'csv'
require 'rails_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/contact_fields'

module DB
  describe ContactFields, :import do
    def contact_fields
      %q(11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ) +
        %q(Example Street, District ,Example Town,  Example County,) +
        %q(E10 7EX, SPAIN)
    end

    describe 'entity' do
      it 'title' do
        row = ContactFields.new parse_line contact_fields

        expect(row.entities.length).to eq 2
      end
    end

    describe '#update_for' do
      def one_entity_field
        %q(11,  Mr,  D, Example, , , , 1, House,  2, ) +
          %q(Road, District, Town, County, E10 7EX, SPAIN)
      end

      it 'updates entity from row source' do
        client = client_new entities: [Entity.new(name: 'Jones')]

        ContactFields.new(parse_line one_entity_field).update_for client

        expect(client.entities[0].full_name).to eq 'Mr D. Example'
      end

      def two_entity_field
        %q(11,  Mr,, One, Mrs, , Two, 1, House,  2, ) +
          %q(Road, District, Town, County, E10 7EX, SPAIN)
      end

      it 'updates both entities' do
        client = client_new entities: [Entity.new(name: 'Uno'),
                                       Entity.new(name: 'Dos')]
        expect(client.entities[0].full_name).to eq 'Uno'
        expect(client.entities[1].full_name).to eq 'Dos'

        ContactFields.new(parse_line two_entity_field).update_for client

        expect(client.entities[0].full_name).to eq 'Mr One'
        expect(client.entities[1].full_name).to eq 'Mrs Two'
      end

      it 'updates address from row source' do
        client = client_new address: address_new(road: 'end')

        ContactFields.new(parse_line contact_fields).update_for client

        expect(client.address.flat_no).to eq '1'
        expect(client.address.house_name).to eq 'ExampleHouse'
        expect(client.address.road_no).to eq '2'
        expect(client.address.road).to eq 'Example Street'
        expect(client.address.district).to eq 'District'
        expect(client.address.town).to eq 'Example Town'
        expect(client.address.county).to eq 'Example County'
        expect(client.address.postcode).to eq 'E10 7EX'
        expect(client.address.nation).to eq 'SPAIN'
      end

      describe 'translations' do
        it 'titleizes town names' do
          lower_case_town_row = \
            %q(11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ) +
            %q(Example Street, District ,example town,  Example County,  ) +
            %q(E10 7EX, SPAIN)
          client = client_new address: address_new(town: 'this town is changed')

          ContactFields.new(parse_line lower_case_town_row).update_for client

          expect(client.address.town).to eq 'Example Town'
        end

        it 'maps abbreviated county names' do
          abbreviated_county = \
            %q(11,  Mr,  D, Example, Mrs, A N, Other&, 1, ExampleHouse,  2, ) +
            %q(Example Street, District ,example town,  Warks, E10 7EX)
          client = client_new address: address_new(county: 'Warks')

          ContactFields.new(parse_line abbreviated_county).update_for client

          expect(client.address.county).to eq 'Warwickshire'
        end
      end
    end

    def parse_line row_string
      CSV.parse_line(row_string,
                     headers: FileHeader.agent_patch,
                     header_converters: :symbol,
                     converters: -> (field) { field ? field.strip : nil }
                    )
    end
  end
end
