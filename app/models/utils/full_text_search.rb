####
#
# FullTextSearch
#
# Returns the full-text search results for a query
#
# Interface between the full-text-search application (Elasticsearch)
# and the application. Calls search methods which are generated
# by the Elasticsearch gem and the searchable module.
#
# rubocop: disable Metrics/MethodLength
#
####
#
class FullTextSearch
  attr_reader :query, :type
  def self.search(type:, query:)
    new(type: type, query: query)
  end

  def initialize(type:, query:)
    @type = type
    @query = query
  end

  def go
    results
  end

  # Instantiate class from name string
  # Object.const_get(type).search(query)
  def results
    case type
    when 'Client'
      success = true
      records = Client.search(query).records.order(:human_ref)
      if records.count.zero?
        success = false
        records = Client.all
      end
      { success: success, records: records, render: 'clients/index' }
    when 'Payment'
      success = true
      records = Payment.search(query, '').records
      if records.count.zero?
        success = false
        records = Payment.all
      end
      { success: success,
        records: records,
        render: 'payments/add_new_payment_index' }
    else
      # HERE
      #
      success = true
      records = Property.search(query, 'human_ref').records
      if records.count.zero?
        success = false
        records = Property.all
      end
      { success: success, records: records, render: 'properties/index' }
    end
  end
end
