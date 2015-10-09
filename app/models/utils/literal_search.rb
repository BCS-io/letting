####
#
# LiteralSearch
#
# Responsible for exact match searches for the application.
#
# Used by search Controller
#
# rubocop: disable Style/AccessorMethodName
#
####
#
class LiteralSearch
  attr_reader :referrer, :query

  # referrer: the model and action of the query being executed - one of Client,
  #           Payment, Property, Arrear or Invoice and any of the actions.
  # query: the search terms being queried on the model
  #
  def self.search(referrer:, query:)
    new(referrer: referrer, query: query)
  end

  # go
  # Executes the query
  # returns LiteralResult - a wrapper for the search results
  #
  def go
    return query_by_referrer if query_by_referrer.found?

    default_ordered_query
  end

  private

  def initialize(referrer:, query:)
    @referrer = referrer
    @query = query
  end

  def query_by_referrer
    @query_by_referrer ||= get_query_by_referrer
  end

  # get_query_by_referrer
  #  - search depending on the request's original controller
  #
  def get_query_by_referrer
    case referrer.controller
    when 'clients' then client_search(query)
    when 'payments' then payments_search(query)
    when 'properties' then property_search(query)
    when 'arrears', 'cycles', 'users', 'invoice_texts', 'invoicings', 'invoices'
      LiteralResult.without_a_search
    else
      fail NotImplementedError, "Missing: #{referrer}"
    end
  end

  def client_search query
    LiteralResult.new action: 'show',
                      controller: 'clients',
                      id: id_or_nil(Client.find_by_human_ref query)
  end

  def payments_search query
    LiteralResult.new \
      action: 'index',
      controller: 'payments',
      records: Payment.includes(account: [property: [:entities]])
        .human_ref(query).by_booked_at
  end

  def property_search query
    LiteralResult.new action: 'show',
                      controller: 'properties',
                      id: id_or_nil(Property.find_by_human_ref query)
  end

  def id_or_nil record
    record ? record.id : nil
  end

  def default_ordered_query
    return property_search(query) if property_search(query).found?
    return client_search(query) if client_search(query).found?

    LiteralResult.no_record_found
  end
end
