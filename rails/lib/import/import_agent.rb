require_relative 'import_base'
require_relative 'contact_fields'

module DB
  ####
  #
  # ImportAgent
  #
  # Imports agents (shipping address for properties)
  #
  # Uses ImportBase and is called during the import process and at no
  # other time. ImportAgent reads in Address2.csv information. It expect that
  # properties information (properties.csv) has already been read in
  # this with property information
  #
  ####
  #
  class ImportAgent < ImportBase
    def initialize  contents, range
      super Agent, contents, range
    end

    def model_prepared
      @model_parent = find_model!(Property).first
      model_parent.prepare_for_form
      @model_imported = AgentWithId.new model_parent.agent
    end

    def find_model model_class
      model_class.where human_ref: row[:human_ref]
    end

    # true filters
    # false allows
    #
    def filtered?
      range.exclude? row[:human_ref].to_i
    end

    def model_assignment
      model_imported.assign_attributes authorized: true
      model_imported.human_ref = row[:human_ref].to_i
      ContactFields.new(row).update_for model_imported
    end
  end
end
