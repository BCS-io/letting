module DB
  # AccountingRow
  # Provides a file row with database related information.
  #
  # Accounts rows being read in do not have the information
  # in terms of the database - this module gives them this.
  # Used with the file row encapsulating files - account_row,
  # debit_row and credit_row.
  #
  module AccountingRow
    def account human_ref: nil
      Property.find_by!(human_ref: human_ref).account
      rescue ActiveRecord::RecordNotFound
        raise DB::PropertyRefUnknown,
              "Property ref: #{human_ref} is unknown.",
              caller
    end

    def charge account:, charge_type:
      Charge.find_by!(account_id: account.id, charge_type: charge_type)
      rescue ActiveRecord::RecordNotFound
        raise DB::ChargeUnknown,
              "Property: #{account.property.human_ref} "\
              "charge_type: #{charge_type}",
              caller
    end

    def charge_code_to_s(charge_code:, human_ref:)
      charge = ChargeCode.to_string charge_code
      fail DB::ChargeCodeUnknown,
           "Property #{human_ref}: Charge code #{charge_code} not convertible",
           caller  \
           unless charge
      charge
    end
  end
end
