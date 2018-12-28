require 'csv'

module DB
  ####
  #
  # CSVTransform
  #
  # Opens a CSV file and reads it into an array of arrays.
  #
  # How does this fit into the larger system?
  #
  # This is the first part of the importing system. The data is available to
  # this system through a number of CSV files. This class if responsible for
  # opening the CSV files and returning the information as an array of arrays.
  # The allows the rest of the system to be unaware of the format of the data.
  #
  # The importing system receives arrays which are indexed by
  # symbols matching the attributes of the models - allowing mass assignment
  # where appropriate.
  #
  # The symbols are set in the headers initializer
  #
  # In short the remaining import system has a class for each model and uses
  # the shared import_base for much of the work.
  # The arrays are read into the import_base where the actual importation
  # occurs.
  #
  ####
  class CSVTransform
    attr_reader :file_name, :headers

    def initialize file_name:,
                   drop_rows: 1,
                   headers: true
      @file_name = file_name
      @drop_rows = drop_rows
      @headers = headers
      missing_csv_message unless exist?
    end

    def exist?
      File.exist? file_name
    end

    def to_a
      CSV.open(file_name,
               encoding: 'windows-1251:utf-8',
               headers: @headers,
               header_converters: :symbol,
               converters: -> (field) { field ? field.strip : nil })
         .read.drop(@drop_rows)
    end

    def missing_csv_message
      warn "Warning: CSVTransform message #{file_name} is missing."
    end
  end
end
