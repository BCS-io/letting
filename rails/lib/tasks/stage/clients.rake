require_relative '../../stage/stage'

STDOUT.sync = true

#
# Clients
#
# Creates the clients staging file in staging/ directory.
#
# stage task - stage tasks take legacy data and overwrite, when necessary,
#              any changes by the patch files and puts the resultant data
#              into the stage directory.
#
namespace :db do
  namespace :stage do
    desc 'Improves legacy client data quality by patching inaccuracies.'
    task :clients do
      Stage.new(file_name: 'import_data/staging/staging_clients.csv',
                input: clients_legacy,
                instructions: [PatchRef.new(patch: patch_clients),
                               ExtractClients.new(extracts: extract_clients)]).stage
    end

    # clients_legacy
    #   - source of the raw legacy data rows
    #
    def clients_legacy
      DB::CSVTransform.new file_name: 'import_data/legacy/clients.csv',
                           headers: DB::FileHeader.client
    end

    # patch_clients
    #   - rows to replace source rows
    #
    def patch_clients
      DB::CSVTransform.new(file_name: 'import_data/patch/clients_patch.csv',
                           headers: DB::FileHeader.client).to_a
    end

    # extract_clients
    #  - rows to remove from source rows
    #
    def extract_clients
      DB::CSVTransform.new(file_name: 'import_data/patch/clients_extract.csv',
                           headers: DB::FileHeader.account).to_a
    end
  end
end
