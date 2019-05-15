require_relative 'import_base'
require_relative 'property_row'
require_relative 'contact_fields'

module DB
  ####
  # ImportProperty
  #
  # Import of Property data into the database.
  #
  # How does this fit into the larger system?
  #
  # Imported data is read by DB::CSVTransform and presented to ImportProperty as
  # array of arrays. The base class, ImportBase, handles the data source
  # and iterates through the array in a loop. ImportProperty overrides
  # the assignment but otherwise the base gets a model, assigns attributes
  # and saves the model to the database for all rows.
  #
  ####
  #
  class ImportProperty < ImportBase
    def initialize contents, range
      super Property, contents, range
    end

    def row= file_row
      @row = PropertyRow.new(file_row)
    end

    def model_prepared
      super
      model_imported.prepare_for_form
    end

    def find_model model_class
      model_class.where human_ref: row.human_ref
    end

    # filtered?
    # Either import row, filtered? false, or ignored filtered? true
    #
    def filtered?
      range.exclude? row.human_ref
    end

    def model_assignment
      model_imported.assign_attributes human_ref: row.human_ref,
                                       client_id: row.client_id
      model_imported.agent.authorized = false if model_is_new
      ContactFields.new(row).update_for model_imported
    end

    def model_is_new
      model_imported.new_record?
    end
  end
end
