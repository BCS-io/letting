require_relative '../../stage/stage'

STDOUT.sync = true

#
# AccInfo
#
# Creates the acc_info staging file in the staging/ directory.
#
# stage task - stage tasks take legacy data and overwrite, when necessary,
#              any changes by the patch files.
#              The resultant data is put into the stage directory.
#
namespace :db do
  namespace :stage do
    desc 'Improves legacy accounts/charge data quality by patching mistakes.'
    task :acc_info do
      Stage.new(file_name: 'import_data/staging/staging_acc_info.csv',
                input: acc_infos_legacy,
                instructions: [PatchAccInfo.new(patch: patch_acc_info),
                               InsertAccInfo.new(insert: restore_acc_info)]
               ).stage
    end

    # acc_infos_legacy
    #  - source of the raw legacy data rows
    #
    def acc_infos_legacy
      DB::CSVTransform.new file_name: 'import_data/legacy/acc_info.csv',
                           headers: DB::FileHeader.charge
    end

    # patch_acc_info
    #   - altering rows
    #
    def patch_acc_info
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_info_patch.csv',
                           headers: DB::FileHeader.charge).to_a
    end

    # rows that should not have been deleted
    #
    def restore_acc_info
      DB::CSVTransform.new(file_name: 'import_data/patch/acc_info_restore.csv',
                           headers: DB::FileHeader.charge).to_a
    end
  end
end
