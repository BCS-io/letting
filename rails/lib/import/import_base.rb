require_relative 'contact_fields'
module DB
  ####
  #
  # ImportBase
  #
  # The base class for the importing models from data arrays
  #
  # All imports use this class to populate the database.
  # A model is saved with each iteration of the import loop
  # 1. The system finds and prepares the current model from the database
  #     - (if available)
  # 2. Assigns the row values to the model
  # 3. Any patches are applied - for import data that is plain wrong but
  #    is not going to be fixed in the source database.
  # 4. Save the model
  #
  # The derived classes supply model_assignment and override the
  # model_prepared, but otherwise mostly use the defaults.
  #
  # Errors do not go to logger
  # rubocop: disable Rails/Output, Metrics/MethodLength
  #
  ####
  #
  class ImportBase
    # model_imported - the model from the reading in the file_row
    # model_parent - sometimes we need to know the parent of the imported row
    #                in these cases we need to call save on parent and not
    #                model_imported
    #
    attr_accessor :model_imported, :model_parent, :range, :row

    # contents - data to be imported - array of arrays indexed
    #            by row no and header symbols.
    # range    - the rows to be imported, default nil
    #
    def self.import(contents, range: 1..100_000)
      new(contents, range).import_loop
    end

    # Imports, builds or assigns application objects
    #
    def import_loop
      @contents.each_with_index do |file_row, index|
        begin
          self.row = file_row
          import_row if allowed?
          show_alive index
        rescue StandardError => e
          puts
          warn "Exception: #{e.message}"
          next
        end
      end
    end

    def import_row
      model_prepared
      model_assignment
      model_persist.save || show_error
    end

    def allowed?
      !filtered?
    end

    def filtered?
      false
    end

    protected

    def initialize klass, contents, range
      @klass = klass
      @contents = contents
      @range = range
    end

    def model_prepared
      @model_imported = find_model(@klass).first_or_initialize
    end

    private

    def find_model _model_class
      raise NotImplementedError
    end

    def find_model! model_class
      model = find_model(model_class)
      fail_parent_record_not_found model_class if model.none?
      model
    end

    def model_persist
      model_parent || model_imported
    end

    def fail_parent_record_not_found model_class
      raise ActiveRecord::RecordNotFound, no_parent_message(model_class)
    end

    def no_parent_message model_class
      "#{model_class} human_ref: #{row[:human_ref]} - Not found"
    end

    # Output Error when import continues but a warning is raised
    #
    def show_error
      output_error(model_persist)
    end

    def output_error model
      warn "human_ref: #{row[:human_ref]} -  #{model.errors.full_messages}"
    end

    # output alive count of '.' every n imported rows
    #
    def show_alive index
      print '.' if true_every_n_counts n: index
    end

    def true_every_n_counts(n:)
      (n % 100).zero? && n.nonzero?
    end
  end
end
