require_relative 'import_base'
require_relative 'contact_fields'

module DB
  ####
  #
  # ImportClient
  #
  # Load and assigns, and saves client models into the database.
  #
  ####
  #
  class ImportClient < ImportBase
    def initialize  contents, range
      super Client, contents, range
    end

    def model_prepared
      super
      model_imported.prepare_for_form
    end

    def find_model model_class
      model_class.where human_ref: row[:human_ref]
    end

    def model_assignment
      model_imported.assign_attributes human_ref: row[:human_ref]
      ContactFields.new(row).update_for model_imported
    end
  end
end
