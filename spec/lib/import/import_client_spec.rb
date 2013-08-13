require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/import'
require_relative '../../../lib/import/import_client'

module DB

  describe 'ImportClient' do
    def headers
      %w{human_id  title1  initials1 name1 title2  initials2 name2 flat_no  housename road_no  road  district  town  county  postcode}
    end

    it "One row" do
      expect{ ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients') }.to \
        change(Client, :count).by 1
    end

    it "One row, 2 Entities" do
      expect{ ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients') }.to \
        change(Entity, :count).by 2
    end

    it "Not double import" do
      expect{ ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients') }.to \
        change(Client, :count).by 1
      expect{ ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients') }.to \
        change(Client, :count).by 0
    end

    it "Not double import" do
      expect{ ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients') }.to \
        change(Entity, :count).by 2
      expect{ ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients') }.to \
        change(Entity, :count).by 0
    end

    context 'entities' do
      it 'adds one entity when second entity blank' do
        expect{ ImportClient.import Import.csv_table 'clients_one_entity', headers: headers, location: 'spec/fixtures/import_data/clients' }.to \
          change(Entity, :count).by 1
      end

      it 'ordered by creation' do
        ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients')
        expect(Client.first.entities[0].created_at).to be < Client.first.entities[1].created_at
      end

      context 'muliple imports' do

        it 'updated changed entities' do
          ImportClient.import Import.csv_table 'clients', headers: headers, location: 'spec/fixtures/import_data/clients'
          ImportClient.import Import.csv_table 'clients_updated', headers: headers, location: 'spec/fixtures/import_data/clients'
          expect(Client.first.entities[0].name).to eq 'Changed'
          expect(Client.first.entities[1].name).to eq 'Other'
        end

        it 'removes deleted second entities' do
          ImportClient.import \
             Import.csv_table 'clients', headers: headers, location: 'spec/fixtures/import_data/clients'
          expect{ ImportClient.import Import.csv_table 'clients_one_entity', headers: headers, location: 'spec/fixtures/import_data/clients' }.to \
            change(Entity, :count).by -1
        end
      end
    end

    context 'patch' do

      it 'if no merge file nothing merged' do
        ImportClient.import Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients')
        expect(Client.first.address.district).to be_blank
      end

      it 'if import file row id does not match patch row id - nothing happens' do
        ImportClient.import   \
        Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients'),  \
        Import.csv_table('clients_no_row_matches', headers: headers, location: 'spec/fixtures/import_data/patch')
        expect(Client.first.address.district).to be_blank
      end

      it 'if import file row id, matches patch row id - the models attributes are changed' do
        ImportClient.import   \
        Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients'),  \
        Import.csv_table('clients_row_match', headers: headers, location: 'spec/fixtures/import_data/patch')
        expect(Client.first.address.district).to eq 'Example District'
      end

      it 'if entities do not match puts error message' do
          $stdout.should_receive(:puts).with(/Cannot match/)
         ImportClient.import   \
         Import.csv_table('clients', headers: headers, location: 'spec/fixtures/import_data/clients'),  \
         Import.csv_table('clients_row_match_name_changed', headers: headers, location: 'spec/fixtures/import_data/patch') # \
      end

    end
  end


end
