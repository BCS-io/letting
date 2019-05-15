require_relative '../modules/method_missing'
require_relative 'errors'

module DB
  ####
  #
  # PropertyRow
  #
  # Encapsulates a properties file row
  # Gives ImportProperty a level of indirection away from the Ruby CSV class.
  #
  # CSV rows are presented as arrays indexed by symbols - example 'client_ref'
  # PropertyRow wraps up one CSV row and provides an interface to
  # ImportProperty. ImportProperty is then only concerned with building and
  # assigning Property classes and not how to get this information.
  #
  #
  ####
  #
  class PropertyRow
    include MethodMissing

    def row
      @source
    end

    def initialize file_row
      @source = file_row
    end

    def human_ref
      row[:human_ref].to_i
    end

    def client_id
      client_ref_to_id
    end

    private

    def client_ref
      row[:client_ref]
    end

    def client_ref_to_id
      Client.find_by!(human_ref: client_ref).id
    rescue ActiveRecord::RecordNotFound
      raise ClientRefUnknown, client_ref_unknown_msg, caller
    end

    def client_ref_unknown_msg
      "Client ref: #{client_ref} is unknown."
    end
  end
end
