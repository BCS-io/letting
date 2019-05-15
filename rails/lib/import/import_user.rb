
require_relative 'import_base'

module DB
  ####
  #
  # Imports users into the application.
  #
  # The source code is freely available on the internet. We require that
  # user information is private and not kept with the source code.
  # The user information is kept in a CSV file.
  #
  # The code is run only during the import process.
  #
  # CSV was chosen because the system uses it for all the other database
  # tables already.
  #
  ####
  #
  class ImportUser < ImportBase
    def initialize contents, range
      super User, contents, range
    end

    def find_model model_class
      model_class.where email: row[:email]
    end

    def model_assignment
      model_imported.assign_attributes nickname:              row[:nickname],
                                       email:                 row[:email],
                                       password:              row[:password],
                                       password_confirmation: row[:password],
                                       role:                  row[:role]
    end
  end
end
