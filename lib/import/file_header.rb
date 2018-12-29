module DB
  ####
  #
  # FileHeader
  #
  # The headings for each column of the appropriate data file mapped to
  # the model's attributes.
  #
  # The import process begins with DB::CSVTransform which opens files and
  # converts them into arrays. When opening the file the columns are
  # mapped to the headers supplied to DB::CSVTransform by calls to this class.
  #
  # import_XXX files such as import_client - reads in a row of data at a time.
  # The client then assigns it's attributes by dereferencing the array with a
  # symbol the same name as the attributes.
  #
  ####
  #
  class FileHeader
    def self.account
      %w[human_ref charge_code at_time description debit credit balance]
    end

    def self.client
      %w[human_ref] + entities + address
    end

    def self.property
      %w[human_ref updated] + entities + address + %w[client_ref]
    end

    def self.agent
      %w[human_ref] + entities + address + %w[nation]
    end

    def self.agent_patch
      agent + %w[override]
    end

    def self.charge
      %w[human_ref updated charge_type charged_in amount payment_type] +
        %w[day_1 month_1 day_2 month_2 day_3 month_3 day_4 month_4] +
        %w[escalation_date escaltion_new_rent]
    end

    def self.user
      %w[nickname email password role]
    end

    def self.entities
      %w[title1 initials1 name1 title2 initials2 name2]
    end

    def self.address
      %w[flat_no house_name road_no road district town county postcode]
    end
  end
end
