require_relative '../../stage/stage'

STDOUT.sync = true

#
# AccItems
#
# Creates the acc_items staging file in the staging/ directory.
#
# stage task - stage tasks take legacy data and overwrite, when necessary,
#              any changes by the patch files and puts the resultant data
#              into the stage directory.
#
namespace :db do
  namespace :stage do
    desc 'Improves legacy accounts/charge data quality by patching mistakes.'
    task :acc_items do
      Stage.new(file_name: 'import_data/staging/staging_acc_items.csv',
                input: acc_items_legacy,
                instructions: [PatchAccItems.new(patch: patch_acc_items),
                               ExtractAccItems.new(extracts: extract_acc_items),
                               InsertAccItems.new(insert: insert_acc_items)]
               ).stage
    end

    # acc_items_legacy
    #   - source of the raw legacy data rows
    #
    def acc_items_legacy
      DB::CSVTransform.new file_name: 'import_data/legacy/acc_items.csv',
                           headers: DB::FileHeader.account
    end

    # patch_acc_items
    #   - rows to replace source rows
    #
    def patch_acc_items
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_items_patch.csv',
                           headers: DB::FileHeader.account).to_a
    end

    # extract_acc_items
    #  - rows to remove from source rows
    #
    def extract_acc_items
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_items_extract.csv',
                           headers: DB::FileHeader.account).to_a
    end

    # insert_acc_items
    #   - rows to add to source rows
    #
    def insert_acc_items
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_items_insert.csv',
                           headers: DB::FileHeader.account).to_a
    end
  end
end
