require_relative '../../stage/stage'

STDOUT.sync = true

#
# Address2
#
# Creates the address2, holding agent data, staging file in the staging/
# directory.
#
# stage task - stage tasks take legacy data and overwrite, when necessary,
#              any changes by the patch files and puts the resultant data
#              into the stage directory.
#
namespace :db do
  namespace :stage do
    desc 'Improves legacy client data quality by patching inaccuracies.'
    task :address2 do
      Stage.new(file_name: 'import_data/staging/staging_address2.csv',
                input: address2_legacy,
                instructions: [PatchRef.new(patch: patch_address2)]).stage
    end

    # address2_legacy
    #   - source of the raw legacy data rows
    #
    def address2_legacy
      DB::CSVTransform.new file_name: 'import_data/legacy/address2.csv',
                           headers: DB::FileHeader.agent
    end

    # patch_acc_items
    #   - rows to replace source rows
    #
    def patch_address2
      DB::CSVTransform.new(file_name: 'import_data/patch/address2_patch.csv',
                           headers: DB::FileHeader.agent_patch).to_a
    end
  end
end
